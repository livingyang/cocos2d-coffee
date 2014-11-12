cc.game.onStart = ->
  cc.view.setDesignResolutionSize 800, 450, cc.ResolutionPolicy.SHOW_ALL
  cc.view.resizeWithBrowserSize true

  #load resources
  cc.LoaderScene.preload ['res/CloseNormal.png', 'res/CloseSelected.png', 'res/HelloWorld.png'], ->
    cc.director.runScene new HelloWorldScene()
  , this

cc.game.run()
