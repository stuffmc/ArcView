# ArcView

Ever wanted to have one or more circles like in the Fitness App from Apple. Sure, you looked at [`HKActivityRingView`](https://developer.apple.com/documentation/healthkit/hkactivityringview) like me and were absolutely, terribly disapointed about the pretty useless non-use-case? ;-)

![](dark.png)
![](light.png)

Have a look here.

You simply need to call `ArcView` with a value of 0 to 1 for `filledSlice` — and you probably want to tweak a bit ArcView itself, e.g. `private let colors: [Color]` which, if you don't need a Gradient, you can simply populate with one single color. Gradients are way cooler though!
