CHEBI_FILE <- system.file("extdata", "chebi_extract.tsv", package="biodb")

test_cacheFiles <- function(conn) {
    
    # Get some ids
    ids <- conn$getEntryIds(3)
    testthat::expect_is(ids, 'character')
    testthat::expect_length(ids, 3)
    
    # Get cache instance
    cache <- conn$getBiodb()$getPersistentCache()

    # Get extension
    ctype <- conn$getPropertyValue('entry.content.type')

    # Erase all files inside cache folder
    cache$deleteAllFiles(conn$getCacheId(), fail=FALSE)
    files <- cache$listFiles(conn$getCacheId(), ext=ctype, full.path=TRUE)
    testthat::expect_is(files, 'character')
    testthat::expect_length(files, 0)
    
    # Get entries
    entries <- conn$getEntry(ids)

    # Get cache file paths
    files <- cache$listFiles(conn$getCacheId(), ext=ctype, full.path=TRUE)
    testthat::expect_is(files, 'character')
    testthat::expect_length(files, 3)
    testthat::expect_true(all(vapply(files, file.exists, FUN.VALUE=TRUE)))
        
    # Get back IDs from cache file names
    idsFromCache <- cache$listFiles(conn$getCacheId(), ext=ctype,
                                    extract.name=TRUE)
    testthat::expect_is(idsFromCache, 'character')
    testthat::expect_length(idsFromCache, 3)
    testthat::expect_equal(ids, idsFromCache)
}

test_deleteFilesForWrongCacheId <- function(biodb) {
    
    cache <- biodb$getPersistentCache()
    
    cacheId <- 'foo-1234567890abcdef01234'
    if (cache$folderExists(cacheId))
        cache$deleteAllFiles(cacheId)
        
    msg <- paste0('^.*No cache folder .* exists for "', cacheId, '".$')
    testthat::expect_warning(cache$deleteAllFiles(cacheId, fail=TRUE), msg,
        perl=TRUE)
}

test_filesExistForConn <- function(conn) {
    cache <- conn$getBiodb()$getPersistentCache()
    testthat::expect_true(cache$filesExist(conn$getCacheId()))
    cache$deleteAllFiles(conn$getCacheId())
    testthat::expect_false(cache$filesExist(conn$getCacheId()))
}

test_noFilesExist <- function(biodb) {
    cache <- biodb$getPersistentCache()
    cacheId <- 'foo-1234567890abcdef01234'
    if (cache$folderExists(cacheId))
        cache$deleteAllFiles(cacheId)
    testthat::expect_false(cache$filesExist(cacheId))
}

test_usedCacheIds <- function(conn) {
    
    conn$deleteAllEntriesFromVolatileCache()
    cache <- conn$getBiodb()$getPersistentCache()
    ids <- conn$getEntryIds(3)
    entries <- conn$getEntry(ids)
    testthat::expect_true(conn$getCacheId() %in% cache$getUsedCacheIds())
    cache$deleteAllFiles(conn$getCacheId())
    testthat::expect_false(conn$getCacheId() %in% cache$getUsedCacheIds())
}

test_deleteAllFiles <- function(conn) {
    
    conn$deleteAllEntriesFromVolatileCache()
    cache <- conn$getBiodb()$getPersistentCache()
    ids <- conn$getEntryIds(3)
    entries <- conn$getEntry(ids)
    testthat::expect_true(cache$filesExist(conn$getCacheId()))
    cache$deleteAllFiles(conn$getCacheId())
    testthat::expect_false(cache$filesExist(conn$getCacheId()))
    
    conn$deleteAllEntriesFromVolatileCache()
    entries <- conn$getEntry(ids)
    testthat::expect_true(cache$filesExist(conn$getCacheId()))
    testthat::expect_error(cache$deleteAllFiles(conn$getCacheId(), prefix=FALSE))
    cache$deleteAllFiles(conn$getCacheId())
    testthat::expect_false(cache$filesExist(conn$getCacheId()))
}

run_tests <- function(impl=c('custom', 'bioc')) {

    impl <- match.arg(impl)

    # Instantiate Biodb
    biodb <- biodb::createBiodbTestInstance()

    # Enable cache system for local dbs
    biodb$getConfig()$set('use.cache.for.local.db', TRUE)
    biodb$getConfig()$set('persistent.cache.impl', impl)

    # Erase whole cache
    biodb$getPersistentCache()$erase()

    # Create connector
    conn <- biodb$getFactory()$createConn('comp.csv.file', url=CHEBI_FILE)

    # Run tests
    biodb::testThat('We can list cache files.', test_cacheFiles, conn=conn)
    biodb::testThat(paste('We got a warning if we try to delete files for a',
        'cache.id that has no associated folder.'),
        test_deleteFilesForWrongCacheId, biodb=biodb)
    biodb::testThat('We detect if cache files exist for a connector',
        test_filesExistForConn, conn=conn)
    biodb::testThat('No cache files exist for unknown cache ID.',
        test_noFilesExist, biodb=biodb)
    biodb::testThat('We can a list of used cache IDs', test_usedCacheIds,
        conn=conn)
    biodb::testThat('We can delete all cache files for a connector',
        test_deleteAllFiles, conn=conn)

    # Terminate Biodb
    biodb$terminate()
}

# Set context
biodb::testContext("Test persistent cache.")

# Test all cache implementations
for (impl in c('custom', 'bioc'))
    run_tests(impl)
