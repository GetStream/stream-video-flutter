package io.getstream.video.flutter.stream_video_flutter.service.notification.image

import android.graphics.*
import coil.bitmap.BitmapPool
import coil.size.Size
import coil.transform.Transformation
import kotlin.math.min


class CircleTransform : Transformation {

    override fun key(): String {
        return "circle"
    }

    override suspend fun transform(pool: BitmapPool, input: Bitmap, size: Size): Bitmap {
        if (input.isRecycled) return input
    
        val sizeImage = min(input.width, input.height)
        if (sizeImage <= 0) return input
        
        val x = (input.width - sizeImage) / 2
        val y = (input.height - sizeImage) / 2
        
        val squaredBitmap = if (x != 0 || y != 0 || sizeImage != input.width || sizeImage != input.height) {
            Bitmap.createBitmap(input, x, y, sizeImage, sizeImage)
        } else {
            input
        }
        
        val config = squaredBitmap.config ?: Bitmap.Config.ARGB_8888
        val output = pool.get(sizeImage, sizeImage, config).apply {
            setHasAlpha(true)
            eraseColor(Color.TRANSPARENT)
        }
        
        val canvas = Canvas(output)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            shader = BitmapShader(squaredBitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        }
        
        val radius = sizeImage / 2f
        canvas.drawCircle(radius, radius, radius, paint)
        
        return output
    }
}