@extends('layouts.app')

@section('title', 'History of the Potato — The Potato Project')
@section('description', 'From the Andes to the world: the 8,000-year story of the potato, the Columbian Exchange, the Irish Famine and the rise of a global staple.')
@section('footer-about', 'Photography courtesy of Wikimedia Commons contributors.')

@section('content')
  <section class="page-hero">
    <div class="container">
      <span class="eyebrow">8,000 years in the making</span>
      <h1>How a wild Andean tuber conquered the world</h1>
      <p class="lead">The potato's journey runs from high mountain terraces to the dinner tables of every continent — by way of empires, famine, and the kitchens of kings.</p>
    </div>
  </section>

  <section class="section">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">The cradle</span>
        <h2>Born in the high Andes</h2>
        <p>Potatoes were first domesticated by the peoples of the Andean highlands of present-day Peru and Bolivia, roughly 8,000 to 10,000 years ago. At altitudes where maize would not grow, the tuber thrived.</p>
        <p>Andean farmers bred thousands of varieties suited to different soils and elevations, and invented <em>chuño</em> — a freeze-dried potato, made using cold mountain nights, that could be stored for years.</p>
      </div>
      <div data-reveal><img src="{{ asset('assets/photos/field.jpg') }}" alt="A potato field" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
    </div>
  </section>

  <section class="section section--tint">
    <div class="container">
      <div class="center" data-reveal><span class="eyebrow">A timeline</span><h2>Milestones in the potato's rise</h2></div>
      <div class="timeline mt-2" style="max-width:760px;margin-left:auto;margin-right:auto" data-reveal>
        @foreach ($events as $event)
        <div class="tl-item"><div class="tl-date">{{ $event->date_label }}</div><p>{{ $event->description }}</p></div>
        @endforeach
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container split">
      <div data-reveal><img src="{{ asset('assets/photos/harvest.jpg') }}" alt="A potato harvest" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
      <div data-reveal>
        <span class="eyebrow">The Columbian Exchange</span>
        <h2>The crop that changed Europe</h2>
        <p>Historians credit the potato with helping to fuel Europe's population boom of the 18th and 19th centuries. Acre for acre it produced far more food than grain, and it grew underground — safe from the trampling and burning of war.</p>
        <p>Cheap, dependable calories underwrote the workforce of the Industrial Revolution. Few foods have shaped the modern world so quietly, or so profoundly.</p>
      </div>
    </div>
  </section>

  <section class="section section--soil">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">A lesson in the dirt</span>
        <h2>Why diversity matters</h2>
        <p>Ireland's famine was sharpened by reliance on a single, genetically uniform variety. When blight arrived, there was no resistant crop to fall back on. The Andes, with their thousands of native potatoes, never faced such a collapse.</p>
        <p>It is a lesson modern agriculture still studies: monocultures are efficient, but fragile. Biodiversity is insurance.</p>
      </div>
      <div data-reveal><img src="{{ asset('assets/photos/flower.jpg') }}" alt="Potato plant in flower" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
    </div>
  </section>
@endsection
