module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        files:
          'signet.js': 'signet.coffee'
          'titleSignet/titleSignet.js': 'titleSignet/titleSignet.coffee'

    watch:
      coffee:
        files: ['signet.coffee', 'titleSignet/titleSignet.coffee']
        tasks: ['coffee', 'uglify']

    uglify:

      signet:
        src: 'signet.js'
        dest: 'signet.min.js'
        options:
          banner: '/*! signet.js <%= pkg.version %> */\n'

      titleSignet:
        src: 'titleSignet/titleSignet.js'
        dest: 'titleSignet/titleSignet.min.js'
        options:
          banner: '/*! titleSignet.js */\n'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'default', ['coffee', 'uglify']