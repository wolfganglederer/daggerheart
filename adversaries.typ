#let json_adversaries = json("adversaries.json")

#let fill-height-with-text(min: 0.3em, max: 5em, eps: 0.1em, it) = layout(size => {
  let fits(text-size, it) = {
    measure(width: size.width, { set text(text-size); it }).height <= size.height
  }

  if not fits(min, it) { panic("Content doesn't fit even at minimum text size") }
  // if fits(max, it) { set text(max); it }

  let (a, b) = (min, max)
  while b - a > eps {
    let new = 0.5 * (a + b)
    if fits(new, it) {
      a = new
    } else {
      b = new
    }
  }

  set text(a)
  it
})



#let main_gray = rgb("#393536")
#set page(paper: "a5", flipped: true)
#set text(font: "Overpass")
#set par(spacing: 8pt, leading: 0.4em)
#set par(hanging-indent: 1em)

#for advers in json_adversaries {
 rect(stroke: 2pt+main_gray, height: 100%, width: 100%)[
 #block()[
  #rect(fill: main_gray, outset: 4pt)[#text(size: 18pt,weight: "extrabold", font: "Overpass", fill: white)[#align(left)[#advers.name]]]
#place(right+top,
  clearance: 0pt,
  dx: 18pt,
  dy: -4pt,
  polygon(fill: main_gray,
  stroke: main_gray,
  (0pt, 0pt),
  (0pt, 30pt),
  (14pt, 0pt),
  ))]

#place(right+top,[*_Tier #advers.tier #advers.type _*]  )

#advers.description
#v(2pt)
#grid(columns: (2fr, 4fr), rows: 8.5cm, column-gutter: 4pt, 
[    #grid(columns: (auto), column-gutter:  0.4em,row-gutter: 8pt,
    [*Difficulty*: #advers.difficulty],
    [*Thresholds: * #advers.thresholds],
    [*Hit Points:*],
    [#v(2pt)#for hp in range(int( advers.hp)) {box(circle(radius: 5pt)); h(3pt)}#v(2pt)],    
    [*Stress:*],
    [#v(2pt)#for stress in range(int( advers.stress)) {box(rect(height: 11pt, width: 11pt)); h(5pt)}#v(2pt)],
    [*Attack:* #advers.atk ],
    [*#advers.attack* #advers.range _#advers.damage _],
    if "experience" in advers [
        *Experience:* \
        #h(0.45em)#str(advers.experience).replace(",", "\n ")
        ] else [#v(-8pt)] ,
[*Motives & Tactics:*],
[#advers.motives_and_tactics],
    )
],
[
#let feats = [#for feat in advers.feats{
            [
              *#feat.name: * #feat.text

            ]
          }
        ]

  #fill-height-with-text(min: 0.5em, max: 1em, feats)
]
)

]
pagebreak()
}
