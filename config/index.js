/**
 * Aggregated object of process.env and window.__config__ to allow dynamic configuration
 */

const viteEnvPrefix = "OFN_VOCABULARY_TOOLS_";
const ENV = {
  ...Object.keys(import.meta.env).reduce((acc, key) => {
    if (key.startsWith(viteEnvPrefix)) {
      const strippedKey = key.replace(viteEnvPrefix, "");
      acc[strippedKey] = import.meta.env[key];
    }
    return acc;
  }, {}),
  ...window.__config__,
};
/**
 * Helper to make sure that all envs are defined properly
 * @param name env variable name
 * @param defaultValue Default variable name
 */
export const getEnv = (name, defaultValue) => {
  const value = ENV[name] || defaultValue;
  if (value !== undefined) {
    return value;
  }
  throw new Error(`Missing environment variable: ${name}`);
};

export const API_URL = getEnv("API_URL");
