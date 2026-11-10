let queue: Promise<unknown> = Promise.resolve();
let serial = 0;

/** Mermaid is loaded only for visible diagrams, and renders are serialized
 * because its configuration is shared between light and dark diagrams. */
export function renderSketch(source: string, dark: boolean): Promise<string> {
  const render = queue.catch(() => {}).then(async () => {
    const { default: mermaid } = await import('mermaid');
    mermaid.initialize({
      startOnLoad: false,
      securityLevel: 'strict',
      htmlLabels: false,
      look: 'handDrawn',
      layout: 'dagre',
      handDrawnSeed: 42,
      theme: 'base',
      fontFamily: 'Kalam, sans-serif',
      flowchart: { htmlLabels: false, curve: 'basis', padding: 24, wrappingWidth: 240 },
      themeVariables: {
        background: dark ? '#171823' : '#ffffff',
        primaryColor: dark ? '#302d4c' : '#eeecff',
        primaryTextColor: dark ? '#eeeff8' : '#292743',
        primaryBorderColor: dark ? '#b8b1ff' : '#5856D6',
        lineColor: dark ? '#acafcb' : '#666481',
        secondaryColor: dark ? '#363249' : '#f1f2ff',
        tertiaryColor: dark ? '#292b3d' : '#f7f7fc',
        edgeLabelBackground: dark ? '#171823' : '#ffffff',
        fontSize: '18px',
      },
    });
    const { svg } = await mermaid.render(`vyuh-sketch-${++serial}`, source);
    return svg;
  });
  queue = render;
  return render;
}
