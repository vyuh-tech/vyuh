<script setup lang="ts">
import TechStack from './components/TechStack.vue';
import FrameworkLayers from './components/FrameworkLayers.vue';
import ActionLink from './components/ActionLink.vue';
import FirstApp from './components/FirstApp.md';
</script>

<template>
  <main class="notebook-home">
    <section class="home-hero">
      <div class="hero-copy">
        <h1>A modular framework to grow your <em><span class="flutter-word">Flutter</span> app.</em></h1>
        <p class="home-tagline">Independent features, shared capabilities, composable apps.</p>
        <p class="home-lead">Build your product one feature at a time. Keep each feature independent, give it the capabilities it needs through plugins, and compose the pieces into apps that can keep growing.</p>
        <div class="home-actions">
          <ActionLink variant="primary" href="/intro/get-started">Build your first feature</ActionLink>
          <ActionLink href="/concepts/why-vyuh">Why build with Vyuh?</ActionLink>
        </div>
        <TechStack />
      </div>
      <FrameworkLayers />
    </section>

    <section class="home-section">
      <div class="section-intro"><h2>Small boundaries.<br>Room to grow.</h2><p>As your product grows, features give teams a place to build independently. Plugins give those features a common foundation. Your app brings them together.</p></div>
      <div class="capability-bento">
        <article class="bento-plugins"><span class="bento-kicker">01 / Plugins</span><h3>One foundation. Many capabilities.</h3><p>Give every feature the same dependable tools. Your app chooses the implementations; features use the shared contracts. Select system plugins, combine analytics and telemetry providers, or add your own capabilities.</p><div class="capability-tags"><span>Authentication</span><span>Networking</span><span>Storage</span><span>Navigation</span><span>Events</span><span>Analytics</span><span>Telemetry</span><span>Environment</span><span>Dependency injection</span><span>Feature flags</span><span>Localization</span><span>Custom plugins</span></div><ActionLink href="/plugins/">Explore plugin capabilities</ActionLink></article>
        <article class="bento-features"><span class="bento-kicker">02 / Features</span><h3>A product slice you can take anywhere.</h3><p>Keep routes, state, UI, and contributions together. Build independently, share a feature package, and compose it into another app.</p><div class="feature-sketch" aria-label="A catalog feature reused in customer and team apps"><span>Catalog feature</span><span>↙ &nbsp; ↘</span><div><span>Customer app</span><span>Team app</span></div></div><ActionLink href="/guides/designing-features">Design portable features</ActionLink></article>
        <article class="bento-lazy"><span class="bento-kicker">03 / Lazy features</span><h3>Bring features in when they’re needed.</h3><p>Declare a route boundary and a loader. Vyuh activates the feature on demand, initializes its dependencies, and installs its routes and contributions.</p><div class="lazy-sketch"><span>Open a route</span><span aria-hidden="true">→</span><span>Load feature</span><span aria-hidden="true">→</span><span>Ready to use</span></div><p class="bento-detail">Concurrent requests share activation. Dart deferred imports can split web code when used in your loader.</p><ActionLink href="/concepts/lazy-features">Understand lazy loading</ActionLink></article>
      </div>
    </section>

    <section class="home-section code-section">
      <div class="section-intro"><h2>Start with Flutter.<br>Add what you need.</h2><p>Begin with a familiar Flutter screen and a feature descriptor. Add another feature when your product needs it, then connect shared capabilities through plugins.</p><ActionLink href="/intro/get-started">Follow the complete setup</ActionLink></div>
      <div class="home-code vp-doc"><div class="code-filename">lib/main.dart</div><FirstApp /></div>
    </section>

    <section class="home-section reading-section">
      <h2>Find your next step.</h2>
      <div class="reading-list">
        <a href="/intro/get-started"><strong>Start building</strong><span>A complete first app and the commands to run it.</span><svg class="action-arrow action-arrow--external" aria-hidden="true" viewBox="0 0 24 24" width="20" height="20"><path d="M4 12h15M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg></a>
        <a href="/concepts/features-and-plugins"><strong>Understand the architecture</strong><span>Ownership, startup, routes, and runtime contracts.</span><svg class="action-arrow action-arrow--external" aria-hidden="true" viewBox="0 0 24 24" width="20" height="20"><path d="M4 12h15M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg></a>
        <a href="/api/"><strong>Look up an API</strong><span>Composition, lifecycle, and shared capability contracts.</span><svg class="action-arrow action-arrow--external" aria-hidden="true" viewBox="0 0 24 24" width="20" height="20"><path d="M4 12h15M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg></a>
        <a href="/examples/"><strong>Study a working feature</strong><span>Counter state, Unsplash API calls, and reusable routes.</span><svg class="action-arrow action-arrow--external" aria-hidden="true" viewBox="0 0 24 24" width="20" height="20"><path d="M4 12h15M13 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" /></svg></a>
      </div>
    </section>
  </main>
</template>
