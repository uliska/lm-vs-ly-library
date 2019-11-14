\version "2.19.81"


bareTime =
#(define-music-function (frac)(fraction?)
   #{
     \time #frac
     s1*0
   #})
