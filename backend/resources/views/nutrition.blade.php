@extends('layouts.app')

@section('title', 'Potato Nutrition — The Potato Project')
@section('description', "What's actually in a potato: calories, carbs, potassium, vitamin C, fibre and the truth about whether potatoes are healthy.")
@section('footer-about', 'Figures from public nutrition databases; for general information only.')

@section('content')
  <section class="page-hero">
    <div class="container">
      <span class="eyebrow">The science</span>
      <h1>Is the potato actually good for you?</h1>
      <p class="lead">In a word: yes. The potato's bad reputation has more to do with deep-fat fryers and lashings of butter than with the tuber itself. Eaten with its skin, it is a genuinely nourishing food.</p>
    </div>
  </section>

  <section class="section">
    <div class="container recipe-cols">
      <div>
        <div class="nutri-panel" data-reveal>
          <h3>Nutrition Facts</h3>
          <p style="margin:0 0 .4rem;font-size:.9rem">One medium potato, baked with skin (173 g)</p>
          @foreach ($nutrients as $nutrient)
          <div @class(['nutri-row', 'major' => $nutrient->is_major, 'thick' => $nutrient->is_thick])
            @if ($nutrient->indented) style="padding-left:1rem" @elseif ($loop->last) style="border:none" @endif>
            <span>{{ $nutrient->name }}</span><span>{{ $nutrient->amount }}</span>
          </div>
          @endforeach
        </div>
      </div>

      <div data-reveal>
        <h2>Percent of your daily needs</h2>
        <p>Those numbers translate into a meaningful share of several key nutrients — especially potassium, where the potato quietly out-performs the banana most people reach for.</p>

        @foreach ($barNutrients as $nutrient)
        <div class="bar-row">
          <div class="bar-label"><span><strong>{{ str_replace('Dietary ', '', $nutrient->name) }}</strong></span><span>{{ $nutrient->percent_dv }}% DV</span></div>
          <div class="bar-track"><div class="bar-fill" style="width:{{ $nutrient->percent_dv }}%"></div></div>
        </div>
        @endforeach
        <p style="font-size:.85rem;color:var(--muted)">DV = Daily Value, based on a 2,000-calorie reference diet. Values vary by variety and cooking method.</p>
      </div>
    </div>
  </section>

  <section class="section section--tint">
    <div class="container">
      <div class="center" data-reveal><span class="eyebrow">Five things worth knowing</span><h2>The honest nutrition picture</h2></div>
      <div class="grid grid--3 mt-2">
        <div class="feature" data-reveal><h3>The skin earns its keep</h3><p>Most of the fibre and a good share of the potassium and B vitamins sit just under the skin. Scrub, don't peel, when you can.</p></div>
        <div class="feature" data-reveal><h3>Cooling builds resistant starch</h3><p>Cook potatoes, then chill them, and some starch becomes resistant starch — a prebiotic that feeds gut bacteria and blunts blood-sugar spikes.</p></div>
        <div class="feature" data-reveal><h3>Naturally fat- and salt-free</h3><p>A plain potato has virtually no fat and almost no sodium. Everything beyond that is what we add to it.</p></div>
        <div class="feature" data-reveal><h3>It's the method, not the tuber</h3><p>Baked or boiled, potatoes are light and filling. Deep-frying is what turns them calorie-dense.</p></div>
        <div class="feature" data-reveal><h3>Surprisingly satiating</h3><p>Boiled potatoes rank among the most filling foods per calorie ever measured, which can help with appetite control.</p></div>
        <div class="feature" data-reveal><h3>Watch the green</h3><p>Green patches and long sprouts contain solanine, which is bitter and mildly toxic. Cut them away or discard very green tubers.</p></div>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">Bottom line</span>
        <h2>A staple, not a guilty pleasure</h2>
        <p>For most of human history the potato kept entire nations fed and healthy. Treated simply — baked, boiled, steamed, eaten skin and all — it remains one of the most affordable, nutritious foods you can put on a plate.</p>
        <a class="btn btn--primary" href="{{ route('recipes') }}">Cook it the good way</a>
      </div>
      <div data-reveal><img src="{{ asset('assets/photos/white.jpg') }}" alt="Halved potato showing pale flesh" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
    </div>
  </section>
@endsection
