<?php

// Allow the Flutter client (and the web build) to call the API from any origin.
// Mobile apps don't enforce CORS, but this makes the browser build work too.
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
