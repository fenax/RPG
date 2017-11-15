(load "gridmap.impl.scm")

(define grid (make-grid 16 10 3))

(use glut gl srfi-42 bindings)

(define window-width 800)
(define window-height 600)

(define display-width 16)
(define display-height 10)
(define edge 16)
(define display-area (make-gridarea 0 0 16 10))


(define screen-scale 3)
(define screen-offset-x
  (/ (- window-width (* display-width edge screen-scale))2))
(define screen-offset-y
  (/ (- window-height (* display-height edge screen-scale))2))

;(define (draw-grid)
 ; (gl:Color3f 1.0 1.0 1.0)
					; (

(define square `((0 0) (0 1) (1 1) (1 0)))

(define (draw-cell x y z)
  (when (= z 2)
	(gl:LoadIdentity)
	(gl:Translatef (+ screen-offset-x (* screen-scale edge x))
		       (+ screen-offset-y (* screen-scale edge y)) 0)
	(gl:Scalef (* screen-scale edge) (* screen-scale edge) 0)
	(draw-square)))

(define (draw-square)
  (gl:Begin gl:LINE_LOOP)
  (for-each (lambda (v)
	      (apply gl:Vertex2f v))
	    square)
  (gl:End))

;(define ev (make-sdl-event))

(define done #f)

(define *display-mode* (+ glut:DOUBLE glut:RGBA glut:DEPTH))
(define *window-title* "loutre")

  (glut:InitDisplayMode *display-mode*)
  (glut:InitWindowSize     window-width window-height)
;  (glut:InitWindowPosition 0 0)
(glut:CreateWindow *window-title*)





(gl:Viewport 0 0 window-width window-height)
(gl:MatrixMode gl:PROJECTION)
(gl:LoadIdentity)
(gl:Ortho 0 window-width 0 window-height -1 100)
(gl:MatrixMode gl:MODELVIEW)
(gl:ClearColor 0.5 0.5 0.5 0.0)
(gl:PointSize 4)


'(let loop ()
  (gl:Clear gl:COLOR_BUFFER_BIT)
   (gl:Color3f 1.0 1.0 1.0)
   (foreach-grid draw-cell grid display-area)
   (gl:Flush)
   (glut:SwapBuffers)
;  (sdl-gl-swap-buffers)
  (let ((evt-type (sdl-event-type ev)))
        (when (not (or (eqv? evt-type SDL_QUIT)
                   (and (eqv? evt-type SDL_KEYDOWN)
			(eqv? (sdl-event-sym ev) SDLK_ESCAPE))))
	      (loop))))

(define (game-display)
  (gl:Clear gl:COLOR_BUFFER_BIT)
   (gl:Color3f 1.0 1.0 1.0)
   (foreach-grid draw-cell grid display-area)
   (gl:Flush)
   (glut:SwapBuffers)
   )
  
(define *game-commands* '())

(define (game-keyboard key mouse-x mouse-y)
  (case key
    ((#\escape) (exit))
    ((glut:KEY_UP)   (display "key up\n"))
    ((glut:KEY_DOWN) (display "key down\n"))
    ((glut:KEY_LEFT) (display "key left\n"))
    ((glut:KEY_RIGHT) (display "key right\n"))
    (else (write (list key mouse-x mouse-y)) (display "pressed \n"))))

(define ((whatever name) #!rest args)
  (write (list name args))
  (display "\n"))


(glut:DisplayFunc game-display)

;(glut:JoystickFunc (whatever 'joystick))

(glut:EntryFunc (whatever 'entry))

(glut:KeyboardFunc game-keyboard) ;(proc key mouse-x mouse-y)
(glut:KeyboardUpFunc (whatever 'keyboard-up))
(glut:IdleFunc (whatever 'idle))
(glut:MotionFunc (whatever 'motion)) ;(proc x y)
(glut:MouseFunc (whatever 'mouse)) ;(proc button up x y)
(glut:PassiveMotionFunc (whatever 'passive-motion)) ;(proc x y)
(glut:SpecialFunc (whatever 'special)) ;(proc key x y)
(glut:SpecialUpFunc (whatever 'special-up)) ;(proc key x y)


(glut:MainLoop)


(exit)
