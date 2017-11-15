(use bind)

					;(bind* "#include <png.h>")
(bind* #<<EOF
#ifndef CHICKEN
#include <png.h>
#endif
EOF
)

(bind* "
char * open_image(char * file, ___out int *x, ___out int *y){
    png_image image;
    memset(&image, 0, (sizeof image));
    image.version = PNG_IMAGE_VERSION;
    *x = *y = 0;
    if (png_image_begin_read_from_file(&image, file)){
        png_bytep buffer;

        image.format = PNG_FORMAT_RGBA;

        buffer = malloc(PNG_IMAGE_SIZE(image));

        if(buffer != NULL && 
            png_image_finish_read(&image, NULL, buffer, 0, NULL))
            {
                 *x = image.width;
                 *y = image.height;
                 return buffer;
            }else{
                 if (buffer == NULL)
                     png_image_free(&image);
                 else
                     free(buffer);
            }
    }
    return NULL;
}

void free(void *);
")

(define (with-image file proc)
  (let-values
      (((buff x y)
	(open_image file)))
    (if (and (< 0 x) (< 0 y))

	(proc buff x y))

    (free buff)
    ))

'(with-image
 "resources/roguelikepack/Spritesheet/roguelikeSheet_transparent.png"
 (lambda (buff x y)
	(display "got picture of ")
	(write (list x y))
	(display "\n")))
	    
	    
