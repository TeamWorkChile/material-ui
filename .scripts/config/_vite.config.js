import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, "src/index.tsx"),
      name: "@teamworkchile/material-ui/{{component}}",
      fileName: "lib/index",
    },
    rollupOptions: {
      external: ["react"],
      output: {
        assetFileNames: `assets/{{component}}.min.[ext]`,
      },
    },
  },
});