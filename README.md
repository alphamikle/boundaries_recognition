# Edge Vision

Edge Vision is a powerful and simple Flutter package **with pure Dart implementation** for detecting document edges and extracting document images with perspective correction. Whether you're building a scanning app, enhancing document recognition workflows, or simply need precise edge detection, Edge Vision is the tool you need.

## Demo

<video width="540" height="1170" controls>
  <source src="https://raw.githubusercontent.com/alphamikle/boundaries_recognition/refs/heads/main/demo.mp4" type="video/mp4">
  No video support
</video>


## Features

- 🚀 **Fast and Accurate Edge Detection**: Identify document edges with high precision, even in challenging conditions.
- 📐 **Accurate Document Cropping with Perspective Correction**: Extracts precise document images based on detected edges and automatically corrects perspective distortion to produce a straight, clean result. (⁉️ Work in progress)
- 📸 **Camera Integration**: Seamlessly integrate with the Flutter camera to process live camera feeds or static images.
- 🖼️ **Flexible Input Options**: Process images from various sources such as camera streams, gallery images, or network inputs.
- 🔥 **Lightweight and Efficient**: Optimized for performance with no impact on UI responsiveness. See more in "Performance" section
- 🔎 **Detailed "Unrecognized" Feedback**: If document edges detection fails, Edge Vision provides comprehensive reasons for the issue, including:
  * Excessive geometric distortion.
  * Document positioned too far from the camera.
  * Document positioned too close to the camera.
  * Low contrast between the document and background ("challenging conditions").
- 🎛️ **Fully Configurable**: Every single parameter of Edge Vision can be adjusted to perfectly suit your application's unique requirements. Tweak detection thresholds, angles, object sizes, and more to craft your ideal document recognition solution.

## Getting Started

### Installation

Add `edge_vision` to your `pubspec.yaml`:

```yaml
dependencies:
  edge_vision: ^0.0.1
```

## Performance (TBD)

The library is already pretty well optimised (but it will be even faster). Current figures:

| Task \ Platform    | Android (Galaxy S24 Ultra) | Android (OnePlus 7 Pro) | iOS (iPhone XR) | iOS (iPhone 16 Pro) |
|--------------------|----------------------------|-------------------------|-----------------|---------------------|
| Recognition FullHD |                            |                         |                 |                     |
| Recognition QuadHD |                            |                         |                 |                     |
|                    |                            |                         |                 |                     |
|                    |                            |                         |                 |                     |
|                    |                            |                         |                 |                     |


## ❗️ Disclaimer ❗️

**This is a very early version of the package.** Changes are possible without backwards compatibility, but it is already suitable for use in production.

## What next?

- [x] Stabilizing API (mostly for the `EdgeVisionSettings`)
- [ ] Built-in object extraction
- [ ] Improve accuracy. The Current rate is about 75% in different environments and 90%+ with "ideal environment"
- [ ] More performance optimizations (Rewriting all the logic with pure Rust to get even higher performance)