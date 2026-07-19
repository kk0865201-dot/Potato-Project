@extends('layouts.app')

@section('title', 'How to Grow Potatoes — The Potato Project')
@section('description', 'A seven-step guide to growing your own potatoes, from chitting seed potatoes to earthing up and harvesting, in a bed, bag or balcony bucket.')
@section('footer-about', 'Photography courtesy of Wikimedia Commons contributors.')

@section('content')
  <section class="page-hero">
    <div class="container">
      <span class="eyebrow">Grow your own</span>
      <h1>From one seed potato to a full harvest</h1>
      <p class="lead">Potatoes are among the most forgiving crops for a beginner. You don't need a field — a deep bag or bucket on a sunny balcony will give you a respectable crop. Here is the whole cycle in seven steps.</p>
    </div>
  </section>

  <section class="section">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">Before you start</span>
        <h2>What you'll need</h2>
        <p>Seed potatoes (certified, not supermarket ones), a sunny spot, loose well-drained soil or compost, and a container at least 30 cm deep if you're not using open ground.</p>
        <div class="pill-row">
          <span class="pill">Full sun</span>
          <span class="pill">Loose, free-draining soil</span>
          <span class="pill">Frost-free planting</span>
          <span class="pill">Roughly 90–120 days</span>
        </div>
      </div>
      <div data-reveal><img src="{{ asset('assets/photos/seed.jpg') }}" alt="Chitting seed potatoes sprouting" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
    </div>
  </section>

  <section class="section section--tint">
    <div class="container">
      <div class="center" data-reveal><span class="eyebrow">The method</span><h2>Seven steps to a harvest</h2></div>
      <div class="grid mt-2" style="gap:18px">
        @foreach ($steps as $step)
        <div class="step-card" data-reveal><div class="step-num">{{ $step->step_number }}</div><div><h3>{{ $step->title }}</h3><p>{{ $step->description }}</p></div></div>
        @endforeach
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container split">
      <div data-reveal><img src="{{ asset('assets/photos/flower.jpg') }}" alt="Potato plant flowering" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
      <div data-reveal>
        <span class="eyebrow">Troubleshooting</span>
        <h2>Common problems, simple fixes</h2>
        <p><strong>Green tubers:</strong> caused by light exposure — earth up more diligently and never eat the green parts.</p>
        <p><strong>Scab on the skin:</strong> usually harmless and cosmetic; avoid liming the soil and keep it evenly watered.</p>
        <p><strong>Blight:</strong> brown patches on leaves in warm, wet spells. Remove affected foliage early and choose blight-resistant varieties next time.</p>
        <p><strong>Hollow centres:</strong> often from uneven watering during rapid growth — aim for steady moisture.</p>
      </div>
    </div>
  </section>

  <section class="section section--soil">
    <div class="container cta-band" data-reveal>
      <span class="eyebrow">The payoff</span>
      <h2>Then cook what you grew</h2>
      <p class="lead mx-auto" style="text-align:center;color:var(--flesh-200)">Few things in the garden are as satisfying as tipping out a bucket and finding it full of potatoes. When you do, we have recipes ready.</p>
      <a class="btn btn--primary" href="{{ route('recipes') }}">Head to the recipes</a>
    </div>
  </section>
@endsection
