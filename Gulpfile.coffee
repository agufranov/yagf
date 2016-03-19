settings =
  jade:
    'test/src/test-jade/jade/**/*.jade': 'test/build'
    'test/src/test-jade/other-jade/**/*.jade': 'test/build/otherjade'
  cleanup: 'test/build'

require('./gulp/jade') settings
require('./gulp/cleanup') settings
