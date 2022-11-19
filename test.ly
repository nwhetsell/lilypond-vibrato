\version "2.22.1"

\include "vibrato.ly"

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
