import { builtinModules } from 'node:module'
import { delimiter, join } from 'node:path'
import { pathToFileURL } from 'node:url'

const builtins = new Set([
  ...builtinModules,
  ...builtinModules.map((name) => `node:${name}`),
])
const globalNodeModules = (process.env.NODE_PATH || '')
  .split(delimiter)
  .filter(Boolean)

async function resolveFromGlobalNodeModules(specifier, context, nextResolve) {
  let lastError

  for (const nodeModulesPath of globalNodeModules) {
    const virtualParent = pathToFileURL(
      join(nodeModulesPath, '__global-esm-entry__.mjs'),
    ).href

    try {
      // Keep Node's ESM resolver so package exports use the `import` condition.
      return await nextResolve(specifier, {
        ...context,
        parentURL: virtualParent,
      })
    } catch (error) {
      if (error?.code !== 'ERR_MODULE_NOT_FOUND') throw error
      lastError = error
      // Try the next NODE_PATH entry before returning Node's normal error.
    }
  }

  throw lastError
}

export async function resolve(specifier, context, nextResolve) {
  const isBareSpecifier =
    !specifier.startsWith('.') &&
    !specifier.startsWith('/') &&
    !specifier.startsWith('file:') &&
    !specifier.startsWith('data:') &&
    !specifier.startsWith('node:') &&
    !specifier.startsWith('#')

  if (!isBareSpecifier || builtins.has(specifier)) {
    return nextResolve(specifier, context)
  }

  try {
    // Preserve normal package and nested dependency resolution first.
    return await nextResolve(specifier, context)
  } catch (error) {
    if (error?.code !== 'ERR_MODULE_NOT_FOUND') throw error
    return resolveFromGlobalNodeModules(specifier, context, nextResolve)
  }
}