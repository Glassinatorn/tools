#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

// TODO: 
// make a recursive function that goes through all the connections and builds a hierchy
// make it possible to position things in corners or mid with "top/mid/..."
// just make the pusher add a buffer between the groups to have the furthest one be just beyond the reach of the other ones
// make the group borders depend on routers
#let nord = (
  // Polar Night
  color1: rgb("#2E3440"),
  color2: rgb("#3B4252"),
  color3: rgb("#434C5E"),
  color4: rgb("#4C566A"),

  // Snow Storm
  color5: rgb("#D8DEE9"),
  color6: rgb("#E5E9F0"),
  color7: rgb("#ECEFF4"),

  // Frost
  color8: rgb("#8FBCBB"), // Light blue-green
  color9: rgb("#88C0D0"), // Medium blue
  color10: rgb("#81A1C1"), // Darker blue
  color11: rgb("#5E81AC"), // Darkest blue

  // Aurora
  color12: rgb("#BF616A"), // Red
  color13: rgb("#D08770"), // Orange
  color14: rgb("#EBCB8B"), // Yellow
  color15: rgb("#A3BE8C"), // Green
  color16: rgb("#B48EAD"), // Purple
)

// setting theme
#set page(fill: nord.color1)
#set text(fill: nord.color9)

// defining components
#let components = (
  "gateway_mta": ( 
    "ip": "102.24.3.1", 
    "connections": (
      "server1", 
      "server2", 
      "server3"
    ) 
  ),
  "router_web": ("ip": "102.10.0.1", "connections": ("gateway_mta")),
  "server1": ("ip": "102.24.11.12", "connections": ("router_web")), 
  "server2": ("ip": "102.24.11.14", "connections": ("router_web")),
  "server3": ("ip": "102.24.11.16", "connections": ("router_web")),
)

// defining connections between components
#let component_connections = (
  "gateway_mta": ("server1", "server2", "server3"),
  "server1": "router_web",
)

// combining everything
#let num_of_components = components.len()

#let nodes = ()
#let n = 0
#while n < components.len() {
  let key = components.keys().at(n)
  let value = components.at(key)

  let title = [#key#linebreak()#value]

  nodes.insert(0, node((0,n), title, fill: nord.color4))

  n = n + 1
}

#let first_key = component_connections.keys().at(1)
#component_connections.at(first_key)

#for (name, connection) in component_connections {
  (name, connection)
}

// creating diagram
#diagram(
  node-fill: gradient.radial(white, blue, radius: 200%),
  node-stroke: blue,
  (
    nodes
  ).intersperse(edge("o--|>")).join()
)
