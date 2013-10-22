module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    uglify:
      signet:
        src: 'signet.js'
        dest: 'signet.min.js'
        options:
          banner: "/*! signet.js <%= pkg.version %> */\n"

  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'default', ['uglify']