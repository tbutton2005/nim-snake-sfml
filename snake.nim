import csfml, random, strutils

# dot type for snake components and food
type
  dot = object
    position, size: Vector2f
    dotcolor: Color

proc draw(this: dot, window: RenderWindow)=
  var rectshape:RectangleShape = newRectangleShape(this.size)
  rectshape.position = this.position
  rectshape.fillColor = this.dotcolor
  window.draw(rectShape)

var
  food = dot(position: vec2(random(40)*20, random(30)*20), size: vec2(20,20), dotcolor: Red)
  isgame = true
  fnt = newFont("font.ttf")

# snake type
type
  direct = enum
    up, left, down, right
  snake = object
    direction: direct
    dots: seq[dot]

proc draw(this: snake, window: RenderWindow)=
  for thisdot in this.dots: thisdot.draw(window)

proc transform(this: var snake)=
  if this.dots.high == -1: this.dots.add(dot(position: vec2(0,600), size: vec2(20,20), dotcolor: White))

  if this.dots[this.dots.low].position == food.position:
    food.position = vec2(random(40)*20, random(30)*20)
    this.dots.add(dot(position: this.dots[this.dots.high].position,size: vec2(20,20), dotcolor: White))

  for dotindex in countdown(this.dots.high,this.dots.low+1):
    this.dots[dotindex].position = this.dots[dotindex-1].position

  case this.direction
  of left:
    if this.dots[this.dots.low].position.x != -20:
      this.dots[this.dots.low].position.x-=20
    else:
      this.dots[this.dots.low].position.x=800
  of right:
    if this.dots[this.dots.low].position.x != 820:
       this.dots[this.dots.low].position.x+=20
    else:
       this.dots[this.dots.low].position.x=0
  of up:
    if this.dots[this.dots.low].position.y != -20:
      this.dots[this.dots.low].position.y-=20
    else:
      this.dots[this.dots.low].position.y=600
  of down:
    if this.dots[this.dots.low].position.y != 620:
      this.dots[this.dots.low].position.y+=20
    else:
      this.dots[this.dots.low].position.y=0
  else: echo "press any key"

  for dotindex in 1..this.dots.high:
    if this.dots[dotindex].position == this.dots[this.dots.low].position and this.dots.high > 0:
      isgame = false

var
  window = newRenderWindow(videoMode(800, 600), "snake")
  snk: snake
  time = 0 # this is for timer

while window.open:
  var event: Event
  while window.pollEvent event:
    if event.kind == EventType.Closed: window.close()
      # control
    if event.kind == EventType.KeyPressed:
      case event.key.code
      of KeyCode.Left:
        if snk.direction != right:
          snk.direction = left
      of KeyCode.Right:
        if snk.direction != left:
          snk.direction = right
      of KeyCode.Up:
        if snk.direction != down:
          snk.direction = up
      of KeyCode.Down:
        if snk.direction != up:
          snk.direction = down
      else: echo "this key isn't allowed"

  window.clear Black

  if isgame:
    inc time
  if time >= 100: # ugly transform code block
    snk.transform()
    time=0

  food.draw(window)
  snk.draw(window)

  var txt:Text
  if isgame:
    txt = newText("Score: "&($(snk.dots.high)), fnt, 24)
    txt.color = White
    txt.position = vec2(20,20)
  else:
    txt = newText("Game Over", fnt, 72)
    txt.color = White
    txt.position = vec2(200,200)


  window.draw(txt)


  window.display()

window.destroy()
