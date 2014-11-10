@ShowHelp = ->
  labHelp = new cc.LabelTTF 'github: https://github.com/livingyang/cocos2d-coffee', 'Arial', 20
  labHelp.setPosition cc.pMult cc.pFromSize(cc.director.getWinSize()), 0.5
  cc.director.getRunningScene().addChild labHelp

  labHelp.setOpacity 0
  labHelp.runAction cc.sequence cc.fadeIn(1), cc.delayTime(1), cc.fadeOut(1), cc.callFunc ->
    @removeFromParent()
  , labHelp
