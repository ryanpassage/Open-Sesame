# Open-Sesame
iOS app to unlock a door for me using Bluetooth beacons.

This is a little Swift app I wrote back in 2015 that interfaces with our automated door lock system to unlock a door when I get nearby.

It uses Bluetooth beacons from Estimote to sense presence and initiate the session with the Emerge door lock system.  Alamofire is used for the web requests.

Unfortunately the usefulness of this app isn't all that great since Bluetooth beacon detection is imperfect and there are delays built in to that system (like moving out of range and back in to range, for example).  So this app wasn't reliable enough to actually use.

Pretty neat when it did work though.

(Also since this is old, it isn't Swift 3 compatible and I don't really have time to update the syntax and verify everything.)
