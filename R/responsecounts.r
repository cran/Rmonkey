responsecounts <- function(
    collector,
    api_key = getOption('sm_api_key'),
    oauth_token = getOption('sm_oauth_token'),
    ...
){
    if(!is.null(collector) && inherits(collector, 'sm_collector'))
        collector <- collector$collector_id
    if(!is.null(api_key)) {
        u <- paste('https://api.surveymonkey.net/v2/surveys/get_response_counts?',
                    'api_key=', api_key, sep='')
    } else
        stop("Must specify 'api_key'")
    if(!is.null(oauth_token))
        token <- paste('bearer', oauth_token)
    else
        stop("Must specify 'oauth_token'")
    h <- add_headers(Authorization=token,
                     'Content-Type'='application/json')
    b <- toJSON(list(collector_id = collector), auto_unbox = TRUE)
    out <- POST(u, config = h, ..., body = b)
    stop_for_status(out)
    content <- content(out, as='parsed')
    if(content$status != 0) {
        warning("An error occurred: ",content$errmsg)
        return(content)
    } else
        return(content$data)
}
