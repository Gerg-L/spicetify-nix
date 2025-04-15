import{_ as a,c as i,o as e,ae as t}from"./chunks/framework.Dh1jimFm.js";const c=JSON.parse('{"title":"Custom Apps","description":"","frontmatter":{},"headers":[],"relativePath":"custom-apps.md","filePath":"custom-apps.md"}'),n={name:"custom-apps.md"};function l(r,s,h,p,o,k){return e(),i("div",null,s[0]||(s[0]=[t(`<h1 id="custom-apps" tabindex="-1">Custom Apps <a class="header-anchor" href="#custom-apps" aria-label="Permalink to &quot;Custom Apps&quot;">​</a></h1><h2 id="using-unpackaged-customapps" tabindex="-1">Using unpackaged customApps <a class="header-anchor" href="#using-unpackaged-customapps" aria-label="Permalink to &quot;Using unpackaged customApps&quot;">​</a></h2><div class="language-nix vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">nix</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;">programs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;">spicetify</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;">enabledCustomApps</span><span style="--shiki-light:#B31D28;--shiki-light-font-style:italic;--shiki-dark:#FDAEB7;--shiki-dark-font-style:italic;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> [</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ({</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">      # The source of the customApp</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">      # make sure you&#39;re using the correct branch</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">      # It could also be a sub-directory of the repo</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">      src</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;"> pkgs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70;">fetchFromGitHub</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        owner</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        repo</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        rev</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        hash</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      };</span></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">      # The actual file name of the customApp usually ends with .js</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">      name</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &quot;&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  })</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">]</span><span style="--shiki-light:#B31D28;--shiki-light-font-style:italic;--shiki-dark:#FDAEB7;--shiki-dark-font-style:italic;">;</span></span></code></pre></div><p>Almost all customApp PR&#39;s will be merged quickly view the git history of /pkgs/apps.nix for PR examples</p><h2 id="official-apps" tabindex="-1">Official Apps <a class="header-anchor" href="#official-apps" aria-label="Permalink to &quot;Official Apps&quot;">​</a></h2><h3 id="newreleases" tabindex="-1">newReleases <a class="header-anchor" href="#newreleases" aria-label="Permalink to &quot;newReleases&quot;">​</a></h3><p>Add a page showing new releases from artists you follow.</p><h3 id="reddit" tabindex="-1">reddit <a class="header-anchor" href="#reddit" aria-label="Permalink to &quot;reddit&quot;">​</a></h3><p>Add a page showing popular music on certain music subreddits.</p><h3 id="lyricsplus" tabindex="-1">lyricsPlus <a class="header-anchor" href="#lyricsplus" aria-label="Permalink to &quot;lyricsPlus&quot;">​</a></h3><p>Add a page with pretty scrolling lyrics.</p><h3 id="marketplace" tabindex="-1">marketplace <a class="header-anchor" href="#marketplace" aria-label="Permalink to &quot;marketplace&quot;">​</a></h3><p>Add a page where you can browse extensions, themes, apps, and snippets. Using the marketplace does not work with this flake, however it is still here in order to allow for browsing.</p><h2 id="community-apps" tabindex="-1">Community Apps <a class="header-anchor" href="#community-apps" aria-label="Permalink to &quot;Community Apps&quot;">​</a></h2><h3 id="localfiles" tabindex="-1">localFiles <a class="header-anchor" href="#localfiles" aria-label="Permalink to &quot;localFiles&quot;">​</a></h3><p>Add a shortcut to see just your local files.</p><h3 id="namethattune" tabindex="-1">nameThatTune <a class="header-anchor" href="#namethattune" aria-label="Permalink to &quot;nameThatTune&quot;">​</a></h3><p>Heardle.app for spicetify. <a href="https://github.com/theRealPadster/name-that-tune" target="_blank" rel="noreferrer">Source</a></p><h3 id="ncsvisualizer" tabindex="-1">ncsVisualizer <a class="header-anchor" href="#ncsvisualizer" aria-label="Permalink to &quot;ncsVisualizer&quot;">​</a></h3><p>NCS-style visualizer for Spicetify <a href="https://github.com/Konsl/spicetify-ncs-visualizer" target="_blank" rel="noreferrer">Source</a></p><h3 id="historyinsidebar" tabindex="-1">historyInSidebar <a class="header-anchor" href="#historyinsidebar" aria-label="Permalink to &quot;historyInSidebar&quot;">​</a></h3><p>Adds a shortcut for the &quot;Recently Played&quot; screen to the sidebar. <a href="https://github.com/Bergbok/Spicetify-Creations" target="_blank" rel="noreferrer">Source</a></p><h3 id="betterlibrary" tabindex="-1">betterLibrary <a class="header-anchor" href="#betterlibrary" aria-label="Permalink to &quot;betterLibrary&quot;">​</a></h3><p>Bring back the centered library. <a href="https://github.com/Sowgro/betterLibrary" target="_blank" rel="noreferrer">Source</a></p>`,24)]))}const u=a(n,[["render",l]]);export{c as __pageData,u as default};
