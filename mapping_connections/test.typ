#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

// TODO: 
// make a loop to hand out weights based on connections
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
  "internet": ( "ip": "10.10.0.1", "connections_to": (), "weight": 0),
  "gateway_mta": ( "ip": "102.24.3.1", "connections_to": ("router_web"), "weight": 0),
  "router_web": ("ip": "102.10.0.1", "connections_to": ("internet"), "weight": 0),
  "server1": ("ip": "102.24.11.12", "connections_to": ("gateway_mta"), "weight": 0), 
  "server2": ("ip": "102.24.11.14", "connections_to": ("gateway_mta"), "weight": 0),
  "server3": ("ip": "102.24.11.16", "connections_to": ("gateway_mta"), "weight": 0),
  "server4": ("ip": "102.24.11.16", "connections_to": ("gateway_mta"), "weight": 0),
)


// combining everything
#let keys = components.keys()
#let tmp = ""

// Loop to evaluate weights for components
#{
  let keys = components.keys()  // Get the keys of the components
  let n = 0
  
  while n < keys.len() {
    let key = keys.at(n)  // Get the current key
    let component = components.at(key)  // Get the component by key
    let connections = component.at("connections_to")  // Get connections

    // Check if connections is an array
    if type(connections) == array {
      for connection in connections {
        // Increment the weight of each connected component
        components.at(connection).at("weight") += 1
      }
    } else if connections != () {
      // If it's a single connection, increment its weight
      components.at(connections).at("weight") += 1
    }

    n = n + 1  // Move to the next component
  }
}


#let nodes = ()
#let n = 0
#while n < components.len() {
  let key = components.keys().at(n)
  let value = components.at(key)

  let title = [#key#linebreak()#value]

  let x_offset = value.at("weight")/2
  let y_offset = value.at("weight")
  //[#key: #value #linebreak()]
  nodes.insert(0, node((x_offset,y_offset), title, fill: nord.color4))

  n = n + 1
}



// creating diagram
#diagram(
  node-fill: gradient.radial(white, blue, radius: 200%),
  node-stroke: blue,
  (
    nodes
  ).intersperse(edge("o--|>")).join()
)
