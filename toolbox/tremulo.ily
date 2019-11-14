\version "2.19.82"

#(define (tremulo-type? obj)
   (and (symbol? obj)
        (memq obj '(slow accel accel-overtie fast))))

tremulo =
#(define-event-function (type)(tremulo-type?)
   (let*
    ((markups
      `((slow .
          ,#{
            ^\markup \epsfile #Y #1.5 "library/tremulo/UUUU.eps"
          #})
        (accel .
          ,#{
            ^\markup \epsfile #Y #1.5 "library/tremulo/UUuuuu.eps"
          #})
        (accel-overtie .
          ,#{
            ^\markup \overtie \epsfile #Y #1.5 "library/tremulo/UUuuuu.eps"
          #})
        (fast .
          ,#{
            ^\markup \epsfile #Y #1.2 "library/tremulo/uuuuuuuu.eps"
          #}))))
    #{
      -\tweak self-alignment-X -0.5
      #(assq-ref markups type)
    #}))
