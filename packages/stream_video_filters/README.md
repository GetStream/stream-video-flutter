## Stream Video Filters
Video filters feature implementation for Stream Video Flutter SDK providing option to add blur or virtual background to your video call. Please see the official package `stream_video_flutter` for detailed information on how it can be used. 

### Web

The filters run in the browser from files this package ships as web-only assets; nothing is loaded from a CDN. To serve them from elsewhere, set `StreamVideoFilters.webOptions` to a `WebVideoFiltersOptions` with that `baseUrl`, holding the files of `web_files`.
