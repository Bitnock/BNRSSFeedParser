## BNRSSFeedParser

#### How to use

BNRSSFeedParser (and its BNPodcastFeedParser) is a one-stop shop for handling HTTP RSS resources. The parsing is quite simplistic, and does not necessarily care too much about the RSS spec. The interface for the objects that are generated try their best to adhere to the standards for their formats.

##### Installation

The library can be installed through CocoaPods

    pod 'BNRSSFeedParser', '~> 2.1'

##### BNRSSFeedParser

The feed parser class handles all of the heavy lifting. The `parseFeedURL:` method:

    - (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNRSSFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure
    
takes the URL of an RSS feed and, optionally, an ETag, a date, and success and failure blocks.

If an ETag is provided, it will be assigned to the `NSURLRequest` that is used to request the RSS data. If it is a match (server returns an HTTP 304), the failure block will be called (no parsing will happen, and no feed will be available from this parser). You can check the `statusCode` of the `NSHTTPURLResponse` passed to the block to determine if the reason was an ETag match.

The failure block will also be called should parsing fail for any other reason.

If a `pubDate` is provided, as item elements of the RSS feed are parsed, their pubDates will be compared to the provided `pubDate`, and parsing will stop when an item is at or before the provided `pubDate`. This happens sequentially, in the order that items appear in the feed; it is meant to improve speed and efficiency, so if items are out of order in the feed, the parser may not find them. Neither the parser nor the feed will know how many (if any) items were not parsed.

Because of the frequency that feed pubDates (ie, the pubDate element that is a child of the channel element) are inaccurate, they are ***ignored***. This prevents the parser from bailing early if the feed pubDate is not in sync (i.e. is earlier) than the most recent feed item.

The parser will, essentially, construct an `NSDictionary` from the RSS feed, with very little validation. All elements, attributes, and text nodes will be carried over to the dictionary in the most sensible way possible. If an element contains only a text node, the value for that element's key in the dictionary will be an `NSString` of the text. If the element also (or only) contains child elements, the value will be an `NSDictionary`; the text node will have a key of `@"__text__"`.

XML element attributes are also mapped to keys in the resulting `NSDictionary` objects.

When homographic siblings (e.g. multiple `<item>` elements) are present, they are put into an `NSArray`. The key for the array in its containing dictionary is the name of the elements; it is not pluralized. In no cases will the parser assume an element is part of a set. I.e. a feed with a single item element will *not* have an array with a single item; it will simply have a dictionary.

This dictionary is converted to a `BNRSSFeed` (or `BNPodcastFeed`) object before it is passed to the `success` block of `parseFeedURL:`

The `BNRSSFeedParser` object itself does has a `feed` property, but it is only available once and if the the XML parsing is complete. You generally should only deal with the feed object as it is passed to the `success` block, and likely will have little need to keep the parser object around beyond that.

#### BNRSSFeed

`BNRSSFeed` is a subclass of `NSDictionary`, and provides typed accessors to the defined properties of an RSS 2.0 channel element. Unlike the raw dictionary generated from the parser, these properties do try to adhere strictly to the RSS specification. 

*Currently, there are some lesser used elements that are not included, such as skipHours. They may be added eventually.*

Elements that are expected to be URLs are returned as `NSURL` objects, as are dates (to `NSDate`). Some properties (e.g. `categories` and `items`) will *always* return an array, regardless of how many elements were included in the feed.

Because `BNRSSFeed` is an `NSDictionary` subclass, you can always get any values parsed from the feed, even if there is no convenience property. The `channel` property returns an `NSDictionary` of all data contained in the original feed's `<rss><channel>` element.

The `items` property returns an `NSArray` of `BNRSSFeedItem` (or `BNPodcastFeedItem`) objects, representing all the item elements that were parsed from the feed. 

#### BNRSSFeedItem

Similar to `BNRSSFeed`, `BNRSSFeedItem` is an `NSDictionary` subclass that provide convenience properties to common elements belongin to RSS feed items.  These are also meant to closely adhere to the specs.

The enclosure property of a `BNRSSFeed` object returns a `BNRSSFeedItemEnclosure` object.

#### BNRSSFeedItemEnclosure

An `NSDictionary` subclass that has property for `url`, `length`, and `type`.

### Podcasts

The podcast subclasses simply provide more specific interfaces for some properties that do no exist for general RSS feeds. These include iTunes-specific elements. Not all podcast related properties are included yet.

### Caveats

While the parser class doesn't generally care about the data in the feed, the object classes do. If a feed includes dates that are not formatted according to the RSS spec, the object properties will fail. If an item includes multiple enclosures, the object will simply return the first one.

`BNRSSFeedParser` will call the `failure` block when `parser:parseErrorOccurred:` is called. According to `NSXMLParser` documentation, when `abortParsing` is invoked, `parser:parseErrorOccurred:` should get called. If a `pubDate` is passed in, and causes parsing to stop, `abortParsing` *is* called. It does not appear, though, that this causes `parser:parseErrorOccurred:` to get called.

The appropriate behavior of `BNRSSFeedParser` is: if parsing is stopped because of a `pubDate`, the `success` block *should* get called, and the `failure` block ***should not*** get called. If the behavior of `abortParsing` changes in the future (such as to match the current documentation), these expecations may not be met.
