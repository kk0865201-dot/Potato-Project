<?php

namespace Database\Seeders;

use App\Models\GrowingStep;
use App\Models\Nutrient;
use App\Models\Recipe;
use App\Models\TimelineEvent;
use App\Models\Variety;
use Illuminate\Database\Seeder;

class ContentSeeder extends Seeder
{
    public function run(): void
    {
        $this->seedVarieties();
        $this->seedRecipes();
        $this->seedNutrients();
        $this->seedTimeline();
        $this->seedGrowingSteps();
    }

    private function seedVarieties(): void
    {
        $rows = [
            [
                'slug' => 'russet',
                'name' => 'Russet',
                'type' => 'Starchy',
                'tag_class' => 'tag--bake',
                'description' => 'Thick netted brown skin, dry fluffy flesh. The definitive baking potato and the backbone of the classic fry.',
                'best_for' => 'baking, mashing, fries',
                'origin' => 'North America',
                'rating' => 4.8,
                'image' => 'assets/photos/russet.jpg',
                'image_alt' => 'Russet potatoes with sprouts',
                'featured' => true,
                'translations' => ['ar' => [
                    'name' => 'راسِت',
                    'type' => 'نشوية',
                    'best_for' => 'الخبز، الهرس، البطاطا المقلية',
                    'origin' => 'أمريكا الشمالية',
                    'description' => 'قشرة بنية شبكية سميكة ولب جاف هش. بطاطا الخبز المثالية وأساس البطاطا المقلية الكلاسيكية.',
                ]],
            ],
            [
                'slug' => 'yukon-gold',
                'name' => 'Yukon Gold',
                'type' => 'All-purpose',
                'tag_class' => null,
                'description' => 'Thin gold skin and rich, buttery yellow flesh. Creamy enough to mash, firm enough to roast.',
                'best_for' => 'mash, roast, soups',
                'origin' => 'Canada',
                'rating' => 4.7,
                'image' => 'assets/photos/yukon.jpg',
                'image_alt' => 'Yukon Gold potatoes',
                'featured' => true,
                'translations' => ['ar' => [
                    'name' => 'يوكن غولد',
                    'type' => 'متعددة الاستخدامات',
                    'best_for' => 'الهرس، التحميص، الحساء',
                    'origin' => 'كندا',
                    'description' => 'قشرة ذهبية رقيقة ولب أصفر غني بنكهة الزبدة. كريمية بما يكفي للهرس، وصلبة بما يكفي للتحميص.',
                ]],
            ],
            [
                'slug' => 'red-potato',
                'name' => 'Red Potato',
                'type' => 'Waxy',
                'tag_class' => 'tag--boil',
                'description' => 'Rosy skin, crisp white flesh that keeps its shape. A salad and boiling favourite.',
                'best_for' => 'salads, boiling, stews',
                'origin' => 'South America',
                'rating' => 4.6,
                'image' => 'assets/photos/red.jpg',
                'image_alt' => 'Red-skinned potatoes',
                'featured' => false,
                'translations' => ['ar' => [
                    'name' => 'البطاطا الحمراء',
                    'type' => 'شمعية',
                    'best_for' => 'السلطات، السلق، اليخنات',
                    'origin' => 'أمريكا الجنوبية',
                    'description' => 'قشرة وردية ولب أبيض مقرمش يحافظ على شكله. المفضلة للسلطات والسلق.',
                ]],
            ],
            [
                'slug' => 'fingerling',
                'name' => 'Fingerling',
                'type' => 'Waxy',
                'tag_class' => 'tag--boil',
                'description' => 'Long, slender, knobbly tubers with a firm bite and nutty flavour. Beautiful roasted whole.',
                'best_for' => 'roasting, salads',
                'origin' => 'Europe',
                'rating' => 4.5,
                'image' => 'assets/photos/fingerling.jpg',
                'image_alt' => 'Fingerling potatoes',
                'featured' => true,
                'translations' => ['ar' => [
                    'name' => 'البطاطا الإصبعية',
                    'type' => 'شمعية',
                    'best_for' => 'التحميص، السلطات',
                    'origin' => 'أوروبا',
                    'description' => 'درنات طويلة نحيلة وعقدية بقضمة صلبة ونكهة تشبه الجوز. رائعة عند تحميصها كاملة.',
                ]],
            ],
            [
                'slug' => 'purple-vitelotte',
                'name' => 'Purple Vitelotte',
                'type' => 'Waxy',
                'tag_class' => null,
                'description' => 'Inky blue-violet inside and out, with a chestnut note. Holds its dramatic colour when steamed.',
                'best_for' => 'steaming, colourful salads',
                'origin' => 'Peru',
                'rating' => 4.4,
                'image' => 'assets/photos/purple.jpg',
                'image_alt' => 'Purple Vitelotte potatoes, one halved',
                'featured' => true,
                'translations' => ['ar' => [
                    'name' => 'البطاطا البنفسجية (فيتلوت)',
                    'type' => 'شمعية',
                    'best_for' => 'التبخير، السلطات الملونة',
                    'origin' => 'بيرو',
                    'description' => 'بنفسجي مزرق داكن من الداخل والخارج مع لمسة من الكستناء. يحافظ على لونه المميز عند التبخير.',
                ]],
            ],
            [
                'slug' => 'maris-piper',
                'name' => 'Maris Piper',
                'type' => 'Starchy',
                'tag_class' => 'tag--bake',
                'description' => "Britain's best-loved chipping potato — fluffy, golden and dependable from chip pan to roasting tin.",
                'best_for' => 'chips, roasties, mash',
                'origin' => 'United Kingdom',
                'rating' => 4.3,
                'image' => 'assets/photos/white.jpg',
                'image_alt' => 'Maris Piper potatoes, one halved',
                'featured' => false,
                'translations' => ['ar' => [
                    'name' => 'ماريس بايبر',
                    'type' => 'نشوية',
                    'best_for' => 'رقائق البطاطا، المحمّصة، الهرس',
                    'origin' => 'المملكة المتحدة',
                    'description' => 'بطاطا الرقائق المفضلة في بريطانيا — هشة وذهبية وموثوقة من مقلاة الرقائق إلى صينية التحميص.',
                ]],
            ],
        ];

        foreach ($rows as $i => $row) {
            Variety::updateOrCreate(['slug' => $row['slug']], $row + ['sort_order' => $i + 1]);
        }
    }

    private function seedRecipes(): void
    {
        $rows = [
            [
                'slug' => 'mashed',
                'title' => 'Silky Mashed Potatoes',
                'summary' => 'Cloud-soft, buttery and lump-free every time.',
                'tag_label' => 'Boil & mash',
                'tag_class' => 'tag--boil',
                'serves' => 4,
                'prep_time' => '10 min',
                'cook_time' => '25 min',
                'best_potato' => 'Yukon Gold',
                'image' => 'assets/photos/mashed.jpg',
                'image_alt' => 'Bowl of mashed potatoes',
                'featured' => true,
                'ingredients' => [
                    '900 g Yukon Gold potatoes, peeled',
                    '120 ml whole milk, warmed',
                    '90 g butter, cut into cubes',
                    'Fine sea salt, to taste',
                    'White pepper, a pinch',
                ],
                'steps' => [
                    'Cut potatoes into even chunks. Start them in cold, well-salted water so they cook through evenly.',
                    'Bring to a gentle simmer and cook 18–20 minutes, until a knife slides in with no resistance.',
                    "Drain well, then return to the warm pan for a minute to steam off excess water — the secret to mash that isn't gluey.",
                    'Pass through a ricer or mash thoroughly. Fold in the butter first, then the warm milk, a little at a time.',
                    'Season with salt and a whisper of white pepper. Serve at once.',
                ],
                'translations' => ['ar' => [
                    'title' => 'بطاطا مهروسة ناعمة',
                    'summary' => 'ناعمة كالسحاب، بطعم الزبدة وخالية من الكتل في كل مرة.',
                    'tag_label' => 'سلق وهرس',
                    'best_potato' => 'يوكن غولد',
                    'ingredients' => [
                        '900 غرام بطاطا يوكن غولد، مقشّرة',
                        '120 مل حليب كامل الدسم، مُدفّأ',
                        '90 غرام زبدة، مقطّعة مكعبات',
                        'ملح بحري ناعم، حسب الرغبة',
                        'فلفل أبيض، رشّة',
                    ],
                    'steps' => [
                        'قطّعي البطاطا إلى قطع متساوية. ابدئي بها في ماء بارد مملّح جيداً لتنضج بالتساوي.',
                        'اتركيها تغلي على نار هادئة واطهيها 18–20 دقيقة حتى تدخل السكين دون مقاومة.',
                        'صفّيها جيداً ثم أعيديها إلى القدر الدافئ لدقيقة لتبخير الماء الزائد — سرّ الهرس غير اللزج.',
                        'مرّريها عبر المهراس أو اهرسيها جيداً. أضيفي الزبدة أولاً ثم الحليب الدافئ تدريجياً.',
                        'تبّليها بالملح ورشّة فلفل أبيض. قدّميها فوراً.',
                    ],
                ]],
            ],
            [
                'slug' => 'fries',
                'title' => 'Perfect Crispy Fries',
                'summary' => 'The twice-cooked trick for a shattering crust.',
                'tag_label' => 'Double-fry',
                'tag_class' => 'tag--fry',
                'serves' => 4,
                'prep_time' => '20 min',
                'cook_time' => '20 min',
                'best_potato' => 'Russet / Maris Piper',
                'image' => 'assets/photos/fries.jpg',
                'image_alt' => 'Golden French fries',
                'featured' => true,
                'ingredients' => [
                    '1 kg Russet potatoes',
                    '2 L neutral oil, for frying',
                    'Flaky sea salt',
                ],
                'steps' => [
                    'Cut potatoes into even 1 cm batons. Soak in cold water 30 minutes to rinse off surface starch, then dry thoroughly.',
                    'First fry: cook at 160°C for 5–6 minutes until soft but pale. Lift out and rest on a rack. This cooks the inside.',
                    'Let them cool for at least 10 minutes — even chilling them helps.',
                    'Second fry: raise the oil to 190°C and fry again 2–3 minutes until deep gold and crisp. This builds the shattering crust.',
                    'Drain, salt immediately while glistening, and eat without delay.',
                ],
                'translations' => ['ar' => [
                    'title' => 'بطاطا مقلية مقرمشة مثالية',
                    'summary' => 'حيلة القلي مرتين للحصول على قشرة مقرمشة.',
                    'tag_label' => 'قلي مزدوج',
                    'best_potato' => 'راسِت / ماريس بايبر',
                    'ingredients' => [
                        '1 كغم بطاطا راسِت',
                        '2 لتر زيت محايد للقلي',
                        'ملح بحري خشن',
                    ],
                    'steps' => [
                        'قطّعي البطاطا أصابع متساوية بسماكة 1 سم. انقعيها في ماء بارد 30 دقيقة لإزالة النشا السطحي ثم جفّفيها جيداً.',
                        'القلي الأول: اقليها على حرارة 160° لمدة 5–6 دقائق حتى تلين دون أن تتلوّن. ارفعيها واتركيها على شبك. هذا ينضج الداخل.',
                        'اتركيها تبرد 10 دقائق على الأقل — حتى تبريدها في الثلاجة يساعد.',
                        'القلي الثاني: ارفعي حرارة الزيت إلى 190° واقليها مجدداً 2–3 دقائق حتى تصبح ذهبية ومقرمشة. هذا يبني القشرة المقرمشة.',
                        'صفّيها وملّحيها فوراً وهي لامعة، وتناوليها دون تأخير.',
                    ],
                ]],
            ],
            [
                'slug' => 'roasted',
                'title' => 'Crispy Roast Potatoes',
                'summary' => 'Fluffy middles, golden ridged edges.',
                'tag_label' => 'Roast',
                'tag_class' => 'tag--bake',
                'serves' => 6,
                'prep_time' => '15 min',
                'cook_time' => '50 min',
                'best_potato' => 'Maris Piper',
                'image' => 'assets/photos/roasted.jpg',
                'image_alt' => 'Seasoned roast potato wedges',
                'featured' => true,
                'ingredients' => [
                    '1.2 kg Maris Piper potatoes, peeled and quartered',
                    '4 tbsp goose fat or olive oil',
                    '1 tsp semolina (optional, for extra crunch)',
                    'Salt, a few sprigs of rosemary',
                ],
                'steps' => [
                    'Heat oven to 220°C. Boil the potatoes in salted water for 8 minutes — they should be just tender at the edges.',
                    'Drain, then shake them hard in the colander to rough up the surfaces. Those fluffy edges become the crunch.',
                    'Heat the fat in a roasting tin until shimmering, then add the potatoes and turn to coat. Dust with semolina if using.',
                    'Roast 40–45 minutes, turning once, until deeply golden and crisp all over.',
                    'Scatter with salt and rosemary and serve straight from the oven.',
                ],
                'translations' => ['ar' => [
                    'title' => 'بطاطا محمّصة مقرمشة',
                    'summary' => 'داخل هش وحواف ذهبية مقرمشة.',
                    'tag_label' => 'تحميص',
                    'best_potato' => 'ماريس بايبر',
                    'ingredients' => [
                        '1.2 كغم بطاطا ماريس بايبر، مقشّرة ومقطّعة أرباعاً',
                        '4 ملاعق كبيرة دهن إوز أو زيت زيتون',
                        'ملعقة صغيرة سميد (اختياري، لمزيد من القرمشة)',
                        'ملح، وبضعة أغصان إكليل الجبل',
                    ],
                    'steps' => [
                        'سخّني الفرن إلى 220°. اسلقي البطاطا في ماء مملّح 8 دقائق — يجب أن تلين عند الحواف فقط.',
                        'صفّيها ثم رجّيها بقوة في المصفاة لتخشين السطح. هذه الحواف الهشة تصبح القرمشة.',
                        'سخّني الدهن في صينية التحميص حتى يلمع، ثم أضيفي البطاطا وقلّبيها لتتغطى. رشّي السميد إن استخدمتِه.',
                        'حمّصيها 40–45 دقيقة مع التقليب مرة، حتى تصبح ذهبية ومقرمشة تماماً.',
                        'رشّي الملح وإكليل الجبل وقدّميها مباشرة من الفرن.',
                    ],
                ]],
            ],
            [
                'slug' => 'gratin',
                'title' => 'Potato Gratin',
                'summary' => 'Layers of potato baked slowly in garlicky cream.',
                'tag_label' => 'Bake',
                'tag_class' => null,
                'serves' => 6,
                'prep_time' => '20 min',
                'cook_time' => '1 hr 10 min',
                'best_potato' => 'Waxy / Red',
                'image' => 'assets/photos/gratin.jpg',
                'image_alt' => 'Golden baked potato gratin',
                'featured' => false,
                'ingredients' => [
                    '1 kg waxy potatoes, thinly sliced',
                    '300 ml double cream',
                    '200 ml whole milk',
                    '1 garlic clove, halved',
                    'Nutmeg, salt, pepper',
                    '80 g Gruyère, grated',
                ],
                'steps' => [
                    'Heat oven to 160°C. Rub a baking dish with the cut garlic, then butter it.',
                    "Warm the cream and milk with the garlic, a good grating of nutmeg, salt and pepper. Don't let it boil.",
                    'Layer the potato slices in the dish, seasoning lightly between layers, then pour over the warm cream.',
                    'Press down so the liquid just covers the top. Scatter over the cheese.',
                    'Bake 60–70 minutes until bubbling and bronzed and a knife meets no resistance. Rest 10 minutes before serving.',
                ],
                'translations' => ['ar' => [
                    'title' => 'غراتان البطاطا',
                    'summary' => 'طبقات من البطاطا مخبوزة ببطء في كريمة بالثوم.',
                    'tag_label' => 'خبز',
                    'best_potato' => 'شمعية / حمراء',
                    'ingredients' => [
                        '1 كغم بطاطا شمعية، مقطّعة شرائح رقيقة',
                        '300 مل كريمة سميكة',
                        '200 مل حليب كامل الدسم',
                        'فص ثوم، مقطوع نصفين',
                        'جوزة الطيب، ملح، فلفل',
                        '80 غرام جبن غرويير، مبشور',
                    ],
                    'steps' => [
                        'سخّني الفرن إلى 160°. افركي طبق الخبز بالثوم المقطوع ثم ادهنيه بالزبدة.',
                        'سخّني الكريمة والحليب مع الثوم وقليل من جوزة الطيب والملح والفلفل. لا تتركيها تغلي.',
                        'رتّبي شرائح البطاطا في الطبق مع التتبيل الخفيف بين الطبقات، ثم اسكبي فوقها الكريمة الدافئة.',
                        'اضغطي حتى يغطّي السائل السطح تماماً. انثري الجبن فوقها.',
                        'اخبزيها 60–70 دقيقة حتى تفور وتتحمّر وتدخل السكين دون مقاومة. اتركيها 10 دقائق قبل التقديم.',
                    ],
                ]],
            ],
            [
                'slug' => 'salad',
                'title' => 'Classic Potato Salad',
                'summary' => 'Tangy, creamy and better the next day.',
                'tag_label' => 'No-fuss',
                'tag_class' => 'tag--boil',
                'serves' => 6,
                'prep_time' => '15 min',
                'cook_time' => '20 min',
                'best_potato' => 'Red / Fingerling',
                'image' => 'assets/photos/salad.jpg',
                'image_alt' => 'Bowl of potato salad',
                'featured' => false,
                'ingredients' => [
                    '1 kg red potatoes, skin on',
                    '4 tbsp mayonnaise',
                    '1 tbsp Dijon mustard',
                    '2 spring onions, sliced',
                    '2 tbsp chopped dill or parsley',
                    '1 tbsp white wine vinegar, salt',
                ],
                'steps' => [
                    'Halve the potatoes and boil in salted water 15–18 minutes, until just tender. Drain.',
                    'While still warm, toss with the vinegar and a little salt — warm potatoes drink in the seasoning.',
                    'Let cool to room temperature, then fold through the mayonnaise and mustard.',
                    'Stir in the spring onions and herbs. Taste and adjust.',
                    'Chill for an hour to let the flavours settle before serving.',
                ],
                'translations' => ['ar' => [
                    'title' => 'سلطة البطاطا الكلاسيكية',
                    'summary' => 'لاذعة وكريمية وألذّ في اليوم التالي.',
                    'tag_label' => 'سهلة',
                    'best_potato' => 'حمراء / إصبعية',
                    'ingredients' => [
                        '1 كغم بطاطا حمراء، بالقشر',
                        '4 ملاعق كبيرة مايونيز',
                        'ملعقة كبيرة خردل ديجون',
                        'حبتا بصل أخضر، مقطّعتان',
                        'ملعقتان كبيرتان شبت أو بقدونس مفروم',
                        'ملعقة كبيرة خل نبيذ أبيض، ملح',
                    ],
                    'steps' => [
                        'قطّعي البطاطا نصفين واسلقيها في ماء مملّح 15–18 دقيقة حتى تلين قليلاً. صفّيها.',
                        'وهي دافئة، قلّبيها مع الخل وقليل من الملح — البطاطا الدافئة تمتصّ التتبيلة.',
                        'اتركيها تبرد لدرجة حرارة الغرفة، ثم أضيفي المايونيز والخردل.',
                        'أضيفي البصل الأخضر والأعشاب. تذوّقي وعدّلي.',
                        'برّديها ساعة لتتجانس النكهات قبل التقديم.',
                    ],
                ]],
            ],
        ];

        foreach ($rows as $i => $row) {
            Recipe::updateOrCreate(['slug' => $row['slug']], $row + ['sort_order' => $i + 1]);
        }
    }

    private function seedNutrients(): void
    {
        // One medium potato, baked with skin (173 g)
        $rows = [
            ['name' => 'Calories', 'amount' => '161', 'percent_dv' => null, 'is_major' => true, 'is_thick' => true],
            ['name' => 'Total Fat', 'amount' => '0.2 g', 'percent_dv' => null],
            ['name' => 'Sodium', 'amount' => '17 mg', 'percent_dv' => null],
            ['name' => 'Total Carbohydrate', 'amount' => '37 g', 'percent_dv' => null, 'is_major' => true],
            ['name' => 'Dietary Fibre', 'amount' => '3.8 g', 'percent_dv' => 14, 'indented' => true, 'show_bar' => true, 'bar_name' => 'Fibre'],
            ['name' => 'Sugars', 'amount' => '2 g', 'percent_dv' => null, 'indented' => true],
            ['name' => 'Protein', 'amount' => '4.3 g', 'percent_dv' => null, 'is_major' => true],
            ['name' => 'Potassium', 'amount' => '926 mg', 'percent_dv' => 26, 'is_thick' => true, 'show_bar' => true],
            ['name' => 'Vitamin C', 'amount' => '19.7 mg', 'percent_dv' => 22, 'show_bar' => true],
            ['name' => 'Vitamin B6', 'amount' => '0.5 mg', 'percent_dv' => 29, 'show_bar' => true],
            ['name' => 'Iron', 'amount' => '1.9 mg', 'percent_dv' => 11, 'show_bar' => true],
        ];

        foreach ($rows as $i => $row) {
            unset($row['bar_name']);
            Nutrient::updateOrCreate(['name' => $row['name']], $row + ['sort_order' => $i + 1]);
        }
    }

    private function seedTimeline(): void
    {
        $rows = [
            ['date_label' => 'c. 8000 BCE', 'description' => 'Wild potatoes are domesticated in the Andes around Lake Titicaca, becoming the staple of mountain societies.'],
            ['date_label' => '1400s', 'description' => 'The Inca Empire builds its food security on the potato, storing chuño in vast state warehouses.'],
            ['date_label' => '1530s–1570s', 'description' => 'Spanish explorers encounter the potato in South America and carry it back across the Atlantic to Europe.'],
            ['date_label' => '1600s–1700s', 'description' => 'Slowly, often reluctantly, Europe adopts the potato. Reformers promote it as a cheap, reliable defence against famine.'],
            ['date_label' => '1845–1852', 'description' => "Potato blight devastates Ireland's single-variety crop. The Great Famine kills around a million people and drives mass emigration."],
            ['date_label' => '1995', 'description' => 'The potato becomes the first vegetable grown in space, aboard the Space Shuttle Columbia.'],
            ['date_label' => '2008', 'description' => 'The United Nations declares the International Year of the Potato, honouring its role in global food security.'],
            ['date_label' => 'Today', 'description' => "Potatoes are the world's fourth-largest food crop, grown in over 150 countries, with China and India leading production."],
        ];

        foreach ($rows as $i => $row) {
            TimelineEvent::updateOrCreate(['date_label' => $row['date_label']], $row + ['sort_order' => $i + 1]);
        }
    }

    private function seedGrowingSteps(): void
    {
        $rows = [
            ['title' => 'Chit the seed potatoes', 'description' => 'Four to six weeks before planting, stand the seed potatoes in an egg box in a cool, light spot. They will grow short, stubby green shoots — this gives them a head start.'],
            ['title' => 'Prepare the ground', 'description' => 'Choose a sunny position and dig in plenty of compost. Potatoes like rich, loose soil that drains freely; they sulk in heavy, waterlogged ground.'],
            ['title' => 'Plant once frost has passed', 'description' => 'Set each chitted tuber shoots-up, about 12 cm deep and 30 cm apart, in rows or one per large bucket. Cover with soil.'],
            ['title' => 'Earth up as they grow', 'description' => 'When shoots reach 20 cm, draw soil up around the stems, leaving the tips poking out. Repeat every few weeks. This protects the developing tubers from light, which turns them green.'],
            ['title' => 'Water and feed', 'description' => "Keep the soil consistently moist, especially once the plants flower — that's when tubers swell. A balanced feed every couple of weeks helps a container crop."],
            ['title' => 'Watch for flowers', 'description' => 'Flowering is your signal that tubers are forming below. For tender "new" potatoes, you can start gently feeling under the soil about now.'],
            ['title' => 'Harvest', 'description' => 'For main-crop potatoes, wait until the foliage yellows and dies back, then lift the whole plant with a fork on a dry day. Let the tubers dry for a few hours before storing them somewhere cool and dark.'],
        ];

        foreach ($rows as $i => $row) {
            GrowingStep::updateOrCreate(['step_number' => $i + 1], $row + ['step_number' => $i + 1]);
        }
    }
}
