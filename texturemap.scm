

(define-record texture-file id filename edge border)

(make-texture-file 'roguelike "resources/roguelikepack/Spritesheet/roguelikeSheet_transparent.png" 16 1)

(define-record texture-map edge file border items)


(make-texture-map 16 "resources/roguelikepack/Spritesheet/roguelikeSheet_transparent.png" 1 '())

(define (load-texture t-map)
  
