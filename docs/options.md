---
title: Options
---

# {{ $frontmatter.title }}

<script setup>
import { data } from "./spicetify.data.js";
import { RenderDocs } from "easy-nix-documentation";
</script>

<RenderDocs :options="data"/>
