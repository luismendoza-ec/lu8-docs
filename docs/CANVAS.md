# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Web Canvas System

## Overview

The Lu8 Web Canvas is the main rendering surface for the Lu8 Virtual Machine (VM) in its browser-based version. It provides real-time pixel-based output at a native resolution of **128x128**, faithfully simulating a retro-style computer screen. All graphical output from the VM is drawn into this canvas.

## Rendering Details

* **Native Resolution**: 128x128 pixels (logical screen size)
* **Scale Factor**: 4x by default (final size: 512x512 pixels)
* **Rendering Context**: 2D Canvas API with `imageSmoothingEnabled` disabled for pixel-accurate scaling
* **Color Handling**: Pixel values are mapped via a palette to `RGBA8888` colors

Rendering is performed using a framebuffer provided by the Lu8 VM. The `putImageData` method is used for maximum control and retro fidelity.

## Keyboard Shortcuts

The canvas system supports a number of keyboard shortcuts for user interaction and media capture:

### ALT + ENTER

Toggles fullscreen mode for the entire Lu8 interface, including the canvas. This allows distraction-free focus and enlarged pixel view.

### F9 – Screenshot

Captures the current contents of the canvas as a PNG image:

* Uses the scaled version of the canvas (e.g., 512x512)
* Downloads automatically with filename: `lu8-screenshot-<timestamp>.png`

### F10 – Video Recording (WebM)

Starts/stops recording of the canvas output into a compressed `.webm` video:

* Uses [CCapture.js](https://github.com/spite/ccapture.js) under the hood
* Scales canvas before capturing for full-resolution output
* Records at 30 FPS by default
* Automatically stops after 10 seconds (configurable)
* Downloads as `lu8-recording-<timestamp>.webm`

Recording is toggled: pressing F10 once starts, pressing again stops.

## Capture Scaling

All screenshots and recordings are scaled from the base 128x128 resolution using a scale factor (usually 4x). This ensures visual clarity without affecting the logical rendering pipeline of the VM.

Scaling is handled via an offscreen canvas (`createScaledCanvas`) which copies the current canvas contents and rescales them before capture.

## Integration

The canvas is tightly integrated with:

* The **Lu8 CPU and PPU**, which write pixel data to the framebuffer
* The **Web UI**, which allows program compilation and execution
* The **render loop**, which handles drawing and optionally frame capture

## Technical Notes

* Canvas element ID: `#screen`
* Focus management ensures canvas receives input when clicked
* The canvas is pixel-locked; no anti-aliasing or smoothing is applied
* All canvas logic is defined in the `WebCanvasSystem` module

## Future Features (Planned)

* Support for GIF/WebM toggle
* On-canvas REC overlay during capture
* Adjustable scale factor (1x to 8x)
* Timeline-based capture preview

---

This documentation applies to the **web version** of Lu8 and may differ from desktop/native versions.