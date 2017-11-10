(load "gridmap.impl.scm")

(define grid (make-grid 16 10 3))

(use sdl-base gl srfi-42 bindings)

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

(define ev (make-sdl-event))

(define done #f)


(sdl-init SDL_INIT_VIDEO)
(sdl-gl-set-attribute SDL_GL_RED_SIZE 8)
(sdl-gl-set-attribute SDL_GL_GREEN_SIZE 8)
(sdl-gl-set-attribute SDL_GL_BLUE_SIZE 8)
(sdl-gl-set-attribute SDL_GL_ALPHA_SIZE 8)
(sdl-gl-set-attribute SDL_GL_DEPTH_SIZE 16)
(sdl-gl-set-attribute SDL_GL_DOUBLEBUFFER 1)

(sdl-set-video-mode window-width window-height 32 SDL_OPENGL)

(gl:Viewport 0 0 window-width window-height)
(gl:MatrixMode gl:PROJECTION)
(gl:LoadIdentity)
(gl:Ortho 0 window-width 0 window-height -1 100)
(gl:MatrixMode gl:MODELVIEW)
(gl:ClearColor 0.5 0.5 0.5 0.0)
(gl:PointSize 4)


(let loop ()
  (gl:Clear gl:COLOR_BUFFER_BIT)
   (gl:Color3f 1.0 1.0 1.0)
  (foreach-grid draw-cell grid display-area)
  (sdl-gl-swap-buffers)
  (let ((evt-type (sdl-event-type ev)))
        (when (not (or (eqv? evt-type SDL_QUIT)
                   (and (eqv? evt-type SDL_KEYDOWN)
			(eqv? (sdl-event-sym ev) SDLK_ESCAPE))))
	      (loop))))

(exit)
