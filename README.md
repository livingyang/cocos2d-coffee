cocos2d-coffee
==============

use coffeescript to develop cocos2d-js project.

Requirements
============
* coffee-script
* gulp
* cocos2d-js

Quick start
===========

1. Create a cocos2d-js project at cocos2d_js_dir

        cocos new -l js cocos2d_js_dir

2. Install cocos2d-coffee

        npm install -g cocos2d-coffee

3. Create a cocos2d-coffee project

         coco create test

4. Try build cocos2d-coffee project.

        cd test
        npm install
        gulp -d path_to/cocos2d_js_dir

5. Run cocos2d-js project.

How to add js library
==============

* put js file to lib folder
* add js path to `jslist` at project.json

FAQ
===

**Q: Why the name is coco?**  
*A: Because 'coco's2d and coffee is made from 'coco'*
