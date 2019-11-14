\version "2.19.80"

#(define (boolean-or-integer? obj)
   (or (boolean? obj) (integer? obj)))

NB =
#(define-event-function (underline)(boolean-or-integer?)
   (make-music 'TextScriptEvent 'text
     (case underline
       ((#t)
         (markup #:underline #:italic "NB"))
       ((#f)
         (markup #:italic "NB"))
       ((2)
        (markup #:double-underline #:italic "NB")))))

