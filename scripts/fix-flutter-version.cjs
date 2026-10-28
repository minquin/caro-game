// Flutter detects its own version with `git -c ... log`. Some build environments restrict git, and
// Flutter then caches the version as "0.0.0-unknown", which makes dependency resolution fail.
// This fills in the git-derived fields of bin/cache/flutter.version.json using plain read-only git commands.
const { execFileSync } = require('node:child_process')
const fs = require('node:fs')
const path = require('node:path')

const flutterRoot = path.resolve(process.argv[2] || 'flutter')
const versionFile = path.join(flutterRoot, 'bin', 'cache', 'flutter.version.json')

const git = (...args) => execFileSync('git', args, { cwd: flutterRoot, encoding: 'utf8' }).trim()

const manifest = JSON.parse(fs.readFileSync(versionFile, 'utf8'))
if (manifest.frameworkVersion !== '0.0.0-unknown' && manifest.repositoryUrl !== 'unknown source') {
  console.log(`Flutter version ${manifest.frameworkVersion} detected`)
  process.exit(0)
}

const version = git('describe', '--tags', '--abbrev=0', 'HEAD')
const commitDate = new Date(git('log', '-n', '1', '--pretty=format:%aI'))

Object.assign(manifest, {
  frameworkVersion: version,
  flutterVersion: version,
  channel: git('rev-parse', '--abbrev-ref', 'HEAD'),
  repositoryUrl: 'https://github.com/flutter/flutter.git',
  frameworkRevision: git('log', '-n', '1', '--pretty=format:%H'),
  frameworkCommitDate: commitDate.toISOString().replace('T', ' ').replace('Z', ''),
})

fs.writeFileSync(versionFile, JSON.stringify(manifest, null, 2))
console.log(`Repaired Flutter version cache: ${version} (${manifest.channel})`)
