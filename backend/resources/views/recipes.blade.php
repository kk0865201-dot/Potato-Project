@extends('layouts.app')

@section('title', 'Potato Recipes — The Potato Project')
@section('description', 'Five reliable potato recipes with full ingredients and method: silky mash, crispy double-fried chips, golden roast potatoes, gratin and potato salad.')
@section('footer-about', 'Photography courtesy of Wikimedia Commons contributors.')

@section('content')
  <section class="page-hero">
    <div class="container">
      <span class="eyebrow">From the kitchen</span>
      <h1>Five recipes worth learning by heart</h1>
      <p class="lead">Master these and you can feed almost anyone. Each one names the potato that works best — because the variety matters as much as the method.</p>
    </div>
  </section>

  @foreach ($recipes as $recipe)
  <section class="section {{ $loop->even ? 'section--tint' : '' }}" id="{{ $recipe->slug }}">
    <div class="container">
      <div class="recipe-head"><span class="tag {{ $recipe->tag_class }}">{{ $recipe->tag_label }}</span><h2 style="margin:0">{{ $recipe->title }}</h2></div>
      <div class="recipe-meta"><span>Serves <b>{{ $recipe->serves }}</b></span><span>Prep <b>{{ $recipe->prep_time }}</b></span><span>Cook <b>{{ $recipe->cook_time }}</b></span><span>Best potato <b>{{ $recipe->best_potato }}</b></span></div>
      <div class="recipe-cols">
        <div><img src="{{ asset($recipe->image) }}" alt="{{ $recipe->image_alt }}" style="border-radius:var(--radius);box-shadow:var(--shadow-md);margin-bottom:1rem" />
          <div class="ingredients">
            <h3>Ingredients</h3>
            <ul>
              @foreach ($recipe->ingredients as $ingredient)
              <li>{{ $ingredient }}</li>
              @endforeach
            </ul>
          </div>
        </div>
        <div class="steps">
          <h3>Method</h3>
          <ol>
            @foreach ($recipe->steps as $step)
            <li>{{ $step }}</li>
            @endforeach
          </ol>
        </div>
      </div>
    </div>
  </section>
  @endforeach
@endsection
