\version "2.22.1"

#(use-modules (ice-9 match))

#(set-object-property! 'curvature-factor 'backend-type? number?)

vibrato =
#(define-music-function (amplitudes wave-length) (list? number?)
   #{
     \once \override TrillSpanner.normalized-endpoints =
       #ly:spanner::calc-normalized-endpoints
     \once \override TrillSpanner.curvature-factor = 0.35
     \once \override TrillSpanner.stencil =
       #(let* ((n-amplitudes-1 (1- (length amplitudes))))
          (grob-transformer
           'stencil
           (lambda (grob original)
             (if
              (ly:stencil? original)
              (match-let* (((left . right) (ly:grob-property grob 'normalized-endpoints))                             (left-idx (inexact->exact (round (* n-amplitudes-1 left))))                             (right-idx (inexact->exact (round (* n-amplitudes-1 right))))
                            (sublist (match (drop (take amplitudes
                                                   (1+ right-idx))
                                             left-idx)
                                      ((one) (list one one))
                                      (lst lst)))
                            (original-ext (ly:stencil-extent original X))
                            (len (interval-length original-ext))
                            ((start . end) original-ext)
                            (position-increment (/ len (1- (length sublist))))                             (thickness (* (ly:grob-property grob 'thickness 1.0)
(ly:staff-symbol-line-thickness grob)))
                            (factor (ly:grob-property grob 'curvature-factor)))
                (make-path-stencil
                 (append
                  `(moveto ,start 0.0)
                  (let loop ((position start)
                             (tail sublist)
                             (last-exact start)
                             (current-sign 1)
                             (acc '()))
                    (if (>= position end)
                        (reverse! acc)
                        (match-let* ((next-position (+ position wave-length))                                      (intermediate1 (+ position (* wave-length factor)))                                      (intermediate2 (+ position (* wave-length (- 1 factor))))
                                     (from-last (- position last-exact))
                                     ((previous-height next-height . _) tail)                                      (height (* current-sign (interval-index
(cons previous-height next-height)
                                                              (+ -1 (* 2 (/ from-last position-increment))))))                                      (path-component `(curveto ,intermediate1 ,height
,intermediate2 ,height
,next-position 0.0))
                               (new-acc (append-reverse path-component acc)))
                          (if (>= from-last position-increment)
                              (loop next-position
                                    (cdr tail)
                                    (+ last-exact position-increment)
                                    (- current-sign)
                                    new-acc)
                              (loop next-position
                                    tail
                                    last-exact
                                    (- current-sign)
                                    new-acc))))))
                 thickness
                 1
                 1
                 #f))
              '()))))
    #})

{
  \vibrato #'(0.5) #0.5
  c'2\startTrillSpan d' e'\stopTrillSpan
}

{
  \vibrato #'(0.5 2.0) #0.5
  c'2\startTrillSpan d' e'\stopTrillSpan
}

{
  \override TrillSpanner.thickness = 2
  \vibrato #'(0.0 2.0) #3.0
  c'1\startTrillSpan d' \break
  e' e'\stopTrillSpan
}

{
  \override TrillSpanner.bound-details.left.padding = -2
  \vibrato #'(0.5 0.5 8 0.0) #0.8
  c'1\startTrillSpan d' \break
  e' e'\stopTrillSpan
}

{
  \override TrillSpanner.bound-details.left.padding = -2
  \vibrato #'(2.5 3.5 8 0.0) #0.8
  c'1\startTrillSpan d' \break
  e' e'\stopTrillSpan
}
