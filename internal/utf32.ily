\version "2.19.50"  %% and higher

% Coded by Aaron Hill
%
% Referenced from
% https://lists.gnu.org/archive/html/lilypond-user/2019-03/msg00150.html
%
%% UTF8 workaround - see the following...
%% http://lists.gnu.org/archive/html/lilypond-user/2018-10/msg00468.html

#(define (utf8->utf32 lst)
  "Converts a list of UTF8-encoded characters into UTF32."
  (if (null? lst) '()
    (let ((ch (char->integer (car lst))))
      (cond
        ;; Characters 0x00-0x7F
        ((< ch #b10000000) (cons ch (utf8->utf32 (cdr lst))))
        ;; Characters 0x80-0x7FF
        ((eqv? (logand ch #b11100000) #b11000000)
          (cons (let ((ch2 (char->integer (cadr lst))))
              (logior (ash (logand ch #b11111) 6)
                      (logand ch2 #b111111)))
            (utf8->utf32 (cddr lst))))
        ;; Characters 0x800-0xFFFF
        ((eqv? (logand ch #b11110000) #b11100000)
          (cons (let ((ch2 (char->integer (cadr lst)))
                      (ch3 (char->integer (caddr lst))))
              (logior (ash (logand ch #b1111) 12)
                      (ash (logand ch2 #b111111) 6)
                      (logand ch3 #b111111)))
            (utf8->utf32 (cdddr lst))))
        ;; Characters 0x10000-0x10FFFF
        ((eqv? (logand ch #b111110000) #b11110000)
          (cons (let ((ch2 (char->integer (cadr lst)))
                      (ch3 (char->integer (caddr lst)))
                      (ch4 (char->integer (cadddr lst))))
              (logior (ash (logand ch #b111) 18)
                      (ash (logand ch2 #b111111) 12)
                      (ash (logand ch3 #b111111) 6)
                      (logand ch4 #b111111)))
            (utf8->utf32 (cddddr lst))))
        ;; Ignore orphaned continuation characters
        ((eqv? (logand ch #b11000000) #b10000000) (utf8->utf32 (cdr lst)))
        ;; Error on all else
        (else (error "Unexpected character:" ch))))))

#(define (utf32->utf8 lst)
  "Converts a list of UTF32-encoded characters into UTF8."
  (if (null? lst) '()
    (let ((ch (car lst)))
      (append (cond
          ;; Characters 0x00-0x7F
          ((< ch #x80) (list (integer->char ch)))
          ;; Characters 0x80-0x7FF
          ((< ch #x800) (list
            (integer->char (logior #b11000000 (logand (ash ch -6) #b11111)))
            (integer->char (logior #b10000000 (logand ch #b111111)))))
          ;; Characters 0x800-0xFFFF
          ((< ch #x10000) (list
            (integer->char (logior #b11100000 (logand (ash ch -12) #b1111)))
            (integer->char (logior #b10000000 (logand (ash ch -6) #b111111)))
            (integer->char (logior #b10000000 (logand ch #b111111)))))
          ;; Characters 0x10000-0x10FFFF
          (else (list
            (integer->char (logior #b11110000 (logand (ash ch -18) #b111)))
            (integer->char (logior #b10000000 (logand (ash ch -12) #b111111)))
            (integer->char (logior #b10000000 (logand (ash ch -6) #b111111)))
            (integer->char (logior #b10000000 (logand ch #b111111))))))
        (utf32->utf8 (cdr lst))))))

#(define (string->utf32 s) (utf8->utf32 (string->list s)))
#(define (utf32->string l) (list->string (utf32->utf8 l)))
