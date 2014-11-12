HelloWorldLayer = cc.Layer.extend
  sprite: null
  ctor: ->

    #////////////////////////////
    # 1. super init first
    @_super()

    #///////////////////////////
    # 2. add a menu item with "X" image, which is clicked to quit the program
    #    you may modify it.
    # ask director the window size
    size = cc.director.getWinSize()

    # add a "close" icon to exit the progress. it's an autorelease object
    closeItem = cc.MenuItemImage.create 'res/CloseNormal.png', 'res/CloseSelected.png', ->
      ShowHelp()
    , this

    closeItem.attr
      x: size.width - 20
      y: 20
      anchorX: 0.5
      anchorY: 0.5

    menu = cc.Menu.create closeItem
    menu.x = 0
    menu.y = 0
    @addChild menu, 1

    #///////////////////////////
    # 3. add your codes below...
    # add a label shows "Hello World"
    # create and initialize a label
    helloLabel = cc.LabelTTF.create "Hello coco !", "Arial", 38

    # position the label on the center of the screen
    helloLabel.x = size.width / 2
    helloLabel.y = 0

    # add the label as a child to this layer
    @addChild helloLabel, 5

    # add "HelloWorld" splash screen"
    @sprite = cc.Sprite.create 'res/HelloWorld.png'
    @sprite.attr
      x: size.width / 2
      y: size.height / 2
      scale: 0.5
      rotation: 180

    @addChild @sprite, 0

    rotateToA = cc.RotateTo.create 2, 0
    scaleToA = cc.ScaleTo.create 2, 1, 1
    @sprite.runAction cc.Sequence.create rotateToA, scaleToA
    helloLabel.runAction cc.Spawn.create(cc.MoveBy.create(2.5, cc.p(0, size.height - 40)), cc.TintTo.create(2.5, 255, 125, 0))

    # test lodash
    console.log _
    console.log _.assign { 'a': 1 }, { 'b': 2 }, { 'c': 3 }
    console.log _.map [1, 2, 3], (n) -> n * 3

    true

@HelloWorldScene = cc.Scene.extend
  onEnter: ->
    @_super()
    layer = new HelloWorldLayer()
    @addChild layer
