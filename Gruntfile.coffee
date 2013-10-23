module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        files:
          'signet.js': 'signet.coffee'
          'draw.js': 'draw.coffee'

    watch:
      coffee:
        files: ['signet.coffee', 'draw.coffee']
        tasks: ['coffee', 'uglify']

    uglify:
      signet:
        src: 'signet.js'
        dest: 'signet.min.js'
        options:
          banner: '/*! signet.js <%= pkg.version %> */\n'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'default', ['coffee', 'uglify']