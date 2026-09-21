import { register } from 'node:module'
import { pathToFileURL } from 'node:url'

register(
  new URL('./global-esm-loader.mjs', import.meta.url),
  pathToFileURL('/usr/local/lib/'),
)