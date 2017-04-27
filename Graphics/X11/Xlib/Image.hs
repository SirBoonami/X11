-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Image
-- Copyright   :  (c) Frederik Eaton 2006
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org, frederik@ofb.net
-- Stability   :  provisional
-- Portability :  portable
--
-- Xlib image routines
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Image(
        Image,
        createImage,
        putImage,
        destroyImage,
        getImage,
        xGetPixel,
        getPixel
        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign (Ptr)
import Foreign.C.Types

import System.IO.Unsafe (unsafePerformIO)

----------------------------------------------------------------
-- Image
----------------------------------------------------------------

-- | interface to the X11 library function @XCreateImage()@.
createImage :: Display -> Visual -> CInt -> ImageFormat -> CInt -> Ptr CChar -> Dimension -> Dimension -> CInt -> CInt -> UnnamedMonad Image
createImage display vis depth format offset dat width height bitmap_pad bytes_per_line =
    fmap Image $ guardNotNull "createImage" (xCreateImage display vis depth format offset dat width height bitmap_pad bytes_per_line)
foreign import ccall unsafe "HsXlib.h XCreateImage"
    xCreateImage :: Display -> Visual -> CInt -> ImageFormat -> CInt ->
        Ptr CChar -> Dimension -> Dimension -> CInt -> CInt -> IO (Ptr Image)

-- | interface to the X11 library function @XPutImage()@.
foreign import ccall unsafe "HsXlib.h XPutImage"
    putImage :: Display -> Drawable -> GC -> Image ->
        Position -> Position -> Position -> Position  -> Dimension -> Dimension -> IO ()

-- | interface to the X11 library function @XDestroyImage()@.
foreign import ccall unsafe "HsXlib.h XDestroyImage"
    destroyImage :: Image -> IO ()

-- | interface to the X11 library function @XGetImage()@.
getImage :: Display -> Drawable -> CInt -> CInt -> CUInt -> CUInt -> CULong -> ImageFormat -> UnnamedMonad Image
getImage display d x y width height plane_mask format =
    fmap Image $ guardNotNull "getImage" (xGetImage display d x y width height plane_mask format)

foreign import ccall unsafe "HsXlib.h XGetImage"
    xGetImage :: Display -> Drawable -> CInt -> CInt -> CUInt -> CUInt -> CULong -> ImageFormat -> IO (Ptr Image)

foreign import ccall unsafe "HsXlib.h XGetPixel"
    xGetPixel :: Image -> CInt -> CInt -> IO CULong

-- | interface to the X11 library function @XGetPixel()@.
getPixel :: Image -> CInt -> CInt -> CULong
getPixel i x y = unsafePerformIO (xGetPixel i x y)

{- don't need XInitImage since Haskell users probably won't be setting
members of the XImage structure themselves -}
-- XInitImage omitted

-- XGetSubImage omitted

