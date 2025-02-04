class AppConstants {
  //App related
  static const String appName = 'DOORI';
  static const int appVersion = 1;

  static const String fontFamily = 'Montserrat';

  //API related
  static const String baseUrl = '';

  //https://dev1.wamatechnology.com/projects/tigp/public/api/v1
  //authentication
  static const String signUpApi = "/register";
  static const String signInApi = '/login';
  static const String logoutApi = '/auth/logout';
  static const String userInfoApi = '/auth/me';
  static const String forgotPasswordApi = '/reset-password';
  static const String dashboardApi = '/dashboard';
  static const String latestData = '/latestData';
  static const String ottDataApi = '/ottData';
  static const String payment = '/auth/payment';
  static const String checkSubscription = '/auth/get-subscription';

  //

  static const connectingDevice = "Connecting";
  static const connectedDevice = "Connected";
  static const disconnectedDevice = "Disconnected";

  static const measure = 'MEASURE';
  static const tools = 'TOOLS';
  static const welcomeBack = 'Welcome back,';
  static const myVitals = 'MY VITALS';
  static const insights = 'INSIGHTS';

  static const current = 'CURRENT';
  static const predicted = 'PREDICTED';

  static const heartRate = 'Heart Rate';
  static const average = 'Average';
  static const healthTips = 'Health Tips';
  static const heartHealth = 'Heart Health';
  static const heartRhythm = 'Heart Rhythm';
  static const visualise = 'Visualise';

  //static const mood = 'Mood';
  static const highest = 'Highest';
  static const lowest = 'Lowest';

  static const heartFunction = 'Heart Function';

  static const averageHeartRate = '';

  static const systolic = 'Systolic :';
  static const diastolic = 'Diastolic :';

  static const oxygenLevel = 'Oxygen Level';
  static const bloodPressure = 'Blood Pressure';
  static const temperature = 'Temperature';
  static const bodyHealth = 'Body Health';
  static const bodyTemperature = 'Body Temperature';
  static const hrVariability = 'HR Variability';

  static const pulsePressure = 'Pulse Pressure';
  static const arterialPressure = 'Arterial Pressure';

  static const strokeVolume = 'Stroke Volume';
  static const cardiacOutput = 'Cardiac Output';

  static const veryHealth = 'Very healthy';
  static const unHealth = 'Unhealthy';
  static const health = 'Healthy';
  static const exited = 'Excited';
  static const normal = 'Normal';
  static const working = 'Working';
  static const activity = 'Activity';

  static const yourHealthIsIn = 'Your health is in good shape';
  static const highProtein =
      'High-protein foods, nuts, and meat can cause body heat.';

  static const selectTheToolYouWantToUse = 'Select the tool you want to use:';

  //static const selectTheVitalsYouWantToMeasure = 'Select the vitals you want to\n measure:';
  //static const estimatedTimeForMeasurement = 'Estimated time for measurement: 60 seconds';

  static const start = 'Start';
  static const stop = 'Stop';

  static const getTheHealthable = 'Get The Healthable';

  static const meditationTest = 'Meditation Test';
  static const evaluateYourMeditation = 'Evaluate your meditation';
  static const tapOnTheThreeDots =
      'Tap on the three dots on the device, then tap on the connect button below';
  static const connectToDevice = 'Connect to device';
  static const previousResults = 'Previous results';
  static const scanStartMessage = 'Tap DOORI to make it discoverable';

  static const relaxed = 'Relaxed';
  static const neutral = 'Neutral';
  static const focused = 'Focused';

  static const addSymptoms = 'Add symptoms';
  static const areYouFeelingIll = 'Are you feeling ill?';
  static const enterYourSymptom =
      'Enter your symptom below and we could guide you through the possible illness and provide you with necessary cures and precautions';

  static const yourHealthAnalysis = 'YOUR HEALTH ANALYSIS';
  static const inDepthAnalysis = 'IN DEPTH ANALYSIS';

  static const measurementComplete = 'Measurement Complete';
  static const whatWereYouDoingBefore =
      'What were you doing before you started measuring?';

  static const sleeping = 'Sleeping';
  static const sitting = 'Sitting';
  static const yourReadings = 'Your Readings';
  static const studying = 'Studying';
  static const walking = 'Walking';
  static const running = 'Running';

  static const totalBodyHealth = 'TOTAL HEART HEALTH';
  static const healthCoinsEarned = 'Health Coins earned :';
  static const retry = 'RETRY';
  static const save = 'SAVE';
  static const exit = 'EXIT';
  static const isFalse = 'false';
  static const isTrue = 'true';

  //
  static const userName = 'Username';
  static const email = 'Email';
  static const password = 'Password';
  static const phone = 'Phone';

  static const login = 'Login';
  static const register = 'Register';

  static const createYourAccount = 'Create your account';
  static const createAnAccount = 'Create an Account';
  static const signIn = 'Sign In';
  static const forgotPassword = 'Forgot password?';

 // static const String noInternet = 'Please check your internet connection';
  static const String passwordSuccess = 'Password successfully send on email';

  // share preference
  static const String apiKey = 'apiKey';
  static const String userPassword = 'userPassword';
  static const String userProfile = 'userProfile';
  static const String userEmail = 'userEmail';
  static const String userMobileNo = 'userMobileNo';
  static const String userId = 'userId';
  static const String isLogin = 'isLogin';
  static const String isOfflineRecordInserted='isOfflineRecordInserted';
  static const String activePlanIndex = "activePlanIndex";
  static const String localVerificationData = "localVerificationData";
  static const String productPriceKey = "productPriceKey";

  static const String userToken = 'userToken';
  static const String userInfo = 'userInfo';

  //Login screen
  static const String welcomeToDoori = 'Welcome to Doori';
  static const String welcomeSubText =
      "Provide your profile details to get started with your health monitoring journey";

  static const String notMember = "Not a member?";
  static const String signUpNow = "Sign up now.";

  //signup screen
  //static const String signIn = "Sign in.";
  static const String name = "Name";
  static const String dateOfBirth = "Date of Birth";
  static const String gender = "Gender";
  static const String confirmPassword = "Confirm password";
  static const String continueText = "CONTINUE";
  static const String alreadyRegister = "Already registered?";

  //dashboard screen
  static const String tipOfTheDay = "TIP OF THE DAY";
  static const String connect = "CONNECT";
  static const String profileDetails = "Profile Details";
  static const String updateDevice = "Update Device";
  static const String customerSupport = "Customer Support";
  static const String aboutApp = "About Doori";

  //static const String logout = "Log Out";
  static const String deactivateAccount = "Deactivate Account";
  static const String shareAppWithFriends = "Share App with friends";

  //static const String connectToOtherDevice = "Connect to another device";
  static const String maintainSocialDistancing = "Maintain social distancing";

  //my Profile
  static const String height = "Height";
  static const String weight = "Weight";

  //reset password
  static const String enterUserName = "Enter username to continue";
  static const String resetPassword = "RESET PASSWORD";

  //personal details screen
  static const String heightInCms = "Height (in cms)";
  static const String weightInKgs = "Weight (in kgs)";
  static const String yes = "Yes";
  static const String no = "No";
  static const String next = "Next";
  static const String selectAnyOne = "Please select any one health habit";
  static const String counsumeNonVeg = "Do you consume non vegeterian food?";
  static const String enterPersonalDetails = "Enter your personal details";
  static const String personalDetailsSubText =
      "The following details will help us give you personalized tips.";

  //
  static const String letsGetStarted = "Let’s get started";
  static const String toBeginYourHealthJourney =
      "To begin your health journey link your Doori Healthable device";

//setup page
  static const String setUpDevice = "Setup DOORI";
  static const String deviceNearYou = "Devices near you";
  static const String scanAgain = "Scan again";
  static const String deviceName = "Doori Healthable";
  static const String setUpDeviceSubText =
      "Connect to Doori to monitor your health vitals"; // and surroundings";

  // Firebase tables -------------------------------------------
  static const String tableUsers = 'Users';
  static const String tableMeasure = 'Measures';
  static const String tableHealthTips = 'HealthTips';
  static const String tableNonVegTips = 'NonVegTips';
  static const String tableVegTips = 'VegTips';
  static const String visualiseTips = 'VisualiseTips';
  static const String symptomsTips = 'SymptomsTips';
  static const String causesTips = 'CausesTips';

  static const String tableBodyHealth = 'bodyHealth';
  static const String tableBMI = 'BMIList';

  static const String strokeVolumeTips = 'StrokeTips';
  static const String cardiacOutPutTips = 'CardiacTips';

  static const String energyTips = 'EnergyTips';
  static const String stressLevelTips = 'StressLevelTips';

  static const String overWeightTips = 'OverWeight';
  static const String underWeightTips = 'UnderWeight';

//---------------------------------------------------------------

  static const String low = 'Low';
  static const String medium = 'Normal';
  static const String high = 'High';

  static const String predictionAI = 'Prediction AI';
  static const String wellnessScore = 'Wellness Score';
  static const String highStressLevelDetected = 'High Stress Level Detected';
  static const String concernLevel = 'Concern level';
  static const String outOf = 'out of';

  static const String predictionText="You might be feeling overwhelmed and anxious. Could be due to Work pressure, personal issues, lack of sleep.";

  static const String heartRateText="Your heart rate has been consistently elevated above 90 bpm, which could be a sign that you're dealing with ongoing stress or pushing your body too hard. It's important to pay attention, as this might be putting extra strain on your heart.";

  // Heart Strain
  //
  static const String heartStrain = 'Heart Strain';


  static List<String> vegTips = [
    'Good fats from vegetables,nuts and seeds can reduce the risk of heart disease,',
    'reach for lean protein sources like a small serving of nuts or peanut butter',
    'Focus on foods like nuts, avocado and olive oil.',
    'eat more organic dairy such as skim milk or unsweetened yogurt',
    'eat more organic dairy such as skim milk or unsweetened yogurt',
    'eat less white breads, sugary cereals, refined pastas or rice',
    'eat more healthy fats, such as raw nuts, olive oil, flaxseeds, and avocados',
    'A healthy heart is one that gets exercised.',
    'Physical activity is essential to heart health.',
    'Atleast 150 minutes of moderate exercise or 75 minutes of vigorous exercise per week is recommended for good heart health.',
    'find a physical activity you enjoy and stick with it.',
    'Enjoy healthy fats, avoid unhealthy ones',
    'Some fats, such as omega-3 fats, can even help heart muscles beat in a steady rhythm.',
    'Limit your added fats, too, by trimming dressings, spreads, sauces and fried foods from your diet whenever you can',
    'Limit or avoid Canned soups and prepared foods, such as frozen dinners',
    'Snap out of a sedentary lifestyle',
    'Even if you exercise, long bouts of sedentary time can hurt your heart health.',
    'get active in your free time.',
    'Build movement into your everyday activities and take frequent breaks to stretch your legs if you work at a desk.',
    'It is recommeneded to stand up for at least one minute every half hour and to take a five minute physically active break every hour. ',
    'Shed excess weight',
    'Excess weight is an enemy to your heart health',
    'Excess weight brings with it a slew of health risks.',
    'Excess belly fat correlates with higher blood pressure and cholesterol levels',
    'Avoid overeating through portion control',
    'Your diet heavily contributes to the health of your heart.',
    'The nutrients you consume can either support a healthy heart of undermine it.',
    'one must remain vigilant in sticking to healthy serving sizes',
    'sleep is essential to your heart health',
    'people who are sleep deprived are at a higher risk for cardiovascular disease',
    'Sleep is a necessity to your overall health,',
    'not getting enough can hurt you in more ways than you may realize, especially for your heart.',
    'The body recovers by repairing itself and replenishing fuel sources with sleep',
    'Eat cholesterol-friendly foods',
    'High levels of bad cholesterol threaten the health of your heart.',
    'Limit the amount of foods that contain saturated fats, which can increase your cholesterol.',
    'Limit foods like butter, lard, fatty meats and full-fat dairy products.',
    'support your diet with foods that can naturally lower your cholesterol',
    'Fill your plate with foods rich in soluble fiber, such as beans, sweet potatoes, berries, plums, broccoli and carrots',
    'music with slower tempos can help you lower your blood pressure and improve your heart rate variability',
    'Listening to music for at least 30 minutes a day can lower blood pressure, slow down heart rate and decrease anxiety',
    'Take care of your teeth',
    ' heart health can be compromised by poor dental hygiene.',
    'bacteria that causes gum disease and increased risk of heart disease.',
    ' stifle stress and help your heart',
    'Managing stress in a healthy way can protect your heart.',
    'French lavender is a popular fragrance that is widely used as a relaxer',
    'Make healthy choices and live a lifestyle that helps your heart stay at its best.',
    'Stop smoking—no ifs, ands, or buts',
    'Stopping smoking can make a huge difference to not just your heart, but your overall health, too.',
    'excess belly fat is linked to higher blood pressure',
    "If you're carrying extra fat, eating fewer calories and exercising more can make a big difference.",
    'having sex can be good for your heart.',
    'Sexual activity may add more than just pleasure to your life.',
    'Engaging in activities such as knitting, sewing, and crocheting can help relieve stress and do your ticker some good.',
    'relaxing hobbies such as woodworking, cooking, or completing jigsaw puzzles, may also help take the edge off stressful days.',
    'Power up your salsa with beans',
    'When paired with low-fat chips or fresh veggies, salsa offers a delicious and antioxidant-rich snack.',
    'Consider mixing in a can of black beans for an added boost of heart-healthy fiber.',
    'rich sources of soluble fiber include oats, barley, apples, pears, and avocados help have a healthy heart',
    'Like other forms of aerobic exercise, music raises your heart rate and gets your lungs pumping.',
    'Eat a diet rich in omega-3 fatty acids for a healthy heart ',
    'Laugh out loud in your daily life.',
    'laughter is good for your heart.',
    'Yoga can help you improve your heart, balance, flexibility, and strength.',
    'yoga has potential to improve heart health.',
    'reduce average salt intake to just half a teaspoon a day',
    'reduce Processed and restaurant-prepared foods as they tend to be especially high in salt.',
    'No matter how much you weigh, sitting for long periods of time could affect your heart',
    'Go for a stroll on your lunch break',
    'enjoy regular exercise in your leisure time.',
    'Keeping your blood pressure, blood sugar, cholesterol, and triglycerides in check is important for good heart health.',
    'Dark chocolate not only tastes delicious, it also contains heart-healthy flavonoids.',
    'The next time you want to indulge your sweet tooth, sink it into a square or two of dark chocolate. No guilt required.',
    'Daily chores can give your heart a little workout, while burning calories too.',
    'Almonds, walnuts, pecans, and other tree nuts deliver a powerful punch of heart-healthy fats, protein, and fiber.',
    'While nuts are full of healthy stuff, they’re also high in calories.',
    'Let your inner child take the lead by enjoying an evening of roller skating, bowling, or laser tag.',
    'owning a pet may help improve your heart and lung function.',
    'Take stock of what you’re eating and avoid foods that are high in saturated fat.',
    'If you don’t normally read nutrition labels, considering starting today',
    'Eating a nutritious breakfast every day can help you maintain a healthy heart',
    'reach for whole grains, such as oatmeal, whole-grain cereals, or whole-wheat toast',
    'reach for low-fat dairy products, such as low-fat milk, yogurt, or cheese',
    'reach for fruits and vegetables',
    'Exercise is essential for good heart health',
    'take the stairs instead of the elevator every once in a while',
    'Park on the far side of the parking lot every once in a while',
    'Walk to a colleague’s desk to talk, instead of emailing them every once in a while',
    'Play with your dog or kids at the park, instead of just watching them. every once in a while',
    'Every little bit of exercise adds up to your heart health',
    'brew up a cup of green or black tea.',
    'Drinking one to three cups of tea per day may help lower your risk of heart problems',
    'Good oral hygiene does more than keep your teeth white and glistening.',
    'bacteria that cause gum disease can also raise your risk of heart disease',
    'The next time you feel overwhelmed, exasperated, or angry, take a stroll.',
    'Even a five-minute walk can help clear your head and lower your stress levels',
    'Taking a half-hour walk every day is recommended for your physical and mental health.',
    'Aerobic fitness is key to keeping your heart healthy',
    'The more muscle mass you build, the more calories you burn which can help you maintain a heart-healthy weight and fitness level.',
    'A sunny outlook may be good for your heart, as well as your mood.',
    'chronic stress, anxiety, and anger can raise your risk of heart disease and stroke.',
    'Maintaining a positive outlook on life may help you stay healthier for longer.',
    'Use up at least as many calories as you take in.',
    'To keep your heart running in top form you need to give it heart healthy fuel.',
    "Ground flaxseed has omega-3's, along with both soluble and insoluble fiber which is good for the heart",
    'Oatmeal is a tasty breakfast food, and another good source of those omega-3 fatty acids which is good for the heart',
    'Oatmeal is a filling breakfast, and you can top it with fresh berries for an even more heart-healthy meal.',
    'Beans have lots of soluble fiber, B-complex vitamins, niacin, folate, magnesium, calcium, and omega-3 fatty acids which is good for the heart',
    'Try black beans on a whole-grain pita tostada with avocado, or combine them with corn kernels and onions to make stuffed bell peppers, it is really healthy for the heart',
    'Add kidney beans to a salad of cucumber, fresh corn, onions, and peppers, then toss with olive oil and apple cider vinegar. It helps the heart',
    'bring black beans and kidney beans together for a delicious, nutritious, heart healthy meal',
    'Nuts have been shown to lower blood cholesterol. And for a heart-healthy nut, almonds make a great choice.',
    'almonds contain plant omega-3 fatty acids, vitamin E, magnesium, calcium, fiber, and heart-favorable monounsaturated and polyunsaturated fats',
    ' you can top your yogurt or salad with almond slivers, helps the heart',
    'Sprinkle almond on a rice or quinoa dish, or spread them across some salmon for a nice crunch and heart healthy meal',
    'Walnuts contain plant omega-3 fatty acids, vitamin E, magnesium, folate, fiber, heart-favorable monosaturated and polyunsaturated fats, and phytosterols.',
    'like almonds, walnuts give salads a hearty crunch. ',
    "Tofu is a great source of protein. It's vegetarian. And it's full of heart-healthy nutrients",
    "Brown rice is not only tasty, it's part of a heart healthy diet too.",
    'Brown rice provides B-complex vitamins, magnesium, and fiber which are heavy for the heart',
    'Soy milk contains isoflavones (a flavonoid), and brings lots of nutrition into your diet and keeps your heart healthy',
    'The protein found in soy milkcan help lower blood cholesterol levels and may provide other heart benefits.',
    'Berries are good for your heart, along with the rest of your body.',
    'Blueberries are packed with nutrients that are part of a heart healthy diet,',
    'Carrots are probably best known as a great source of carotenes which makes the heart healthy',
    'Spinach packs a heart-healthy punch with beta-carotene, vitamins C and E, potassium, folate, calcium, and fiber.',
    'Spinach makes a great base for salads and can be used on sandwiches in lieu of lettuce also keeps your heart healthy',
    'Broccoli is a powerhouse vegetable with beta-carotene, vitamins C and E, potassium, folate, calcium, and fiber which helps your heart greatly',
    'Adding more broccoli to your diet is a sure way to improve the health of your heart.',
    'Sweet potatoes are an excellent source of vitamins and help your heart too',
    'Yams are healthy for the heart too',
    'Red bell peppers are tangy, crunchy, and full of heart-healthy nutrients',
    'Red peppers store significant amount of beta-carotene which is good for the heart',
    'Asparagus is a healthy veggie that contains beta-carotene and lutein which helps the heart',
    'Orange juice can also offer great benefits to your heart',
    'Tomatoes are a versatile heart-healthy food with beta- and alpha-carotene, lycopene, lutein (carotenoids), vitamin C, potassium, folate, and fiber.',
    'Acorn squash is a heart-healthy food with beta-carotene and lutein (carotenoids), B-complex and C vitamins, folate, calcium, magnesium, potassium, and fiber.',
    'Oranges are juicy and filled with nutrients which are very healthy for the heart',
    'Cantaloupe is a summertime favorite that also contains heart-healthy nutrients',
    'Papaya is a heart-healthy food contains the carotenoids beta-carotene, beta-cryptoxanthin, and lutein ',
    'Chocolate contains heart-healthy resveratrol and cocoa phenols (flavonoids), which can lower blood pressure.',
    'tea contains catechins and flavonols, which can help maintain the health of your heart and blood vessels, and may keep blood clots from forming.',
    'Tea may reduce your risk for heart problems',
    'Include plant foods as sources of protein, including soybeans, pinto beans, lentils and nuts.',
    'When you make a stew or soup, refrigerate leftovers and skim off the fat with a spoon before reheating and serving.',
    'Replace higher-fat cheeses with lower-fat options such as reduced-fat feta and part-skim mozzarella.',
    "Thicken sauces with evaporated fat-free milk instead of whole milk.",
    'Use small amounts of oils such as canola and olive in recipes and for sautéing.',
    'Make salad dressings with olive or flaxseed oil.',
    'Use liquid vegetable oils and soft margarine instead of stick margarine or shortening.',
    'Limit trans fats often found in foods such as cakes, cookies, crackers, pastries, pies, muffins, doughnuts and french fries.',
    'Move toward using lower-fat milk and yogurt.',
    'Select oils that provide omega-3 fatty acids, such as canola or flaxseed oil.',
    'Add walnuts to cereal, salads or muffins. Try walnut oil in salad dressings, too.',
    'Prepare foods at home so you can control the amount of salt in your meals.',
    'Use as little salt in cooking as possible. You can cut at least half the salt from most recipes.',
    'Add no additional salt to food at the table.',
    'Select reduced-sodium or no-salt-added canned soups and vegetables.',
    'Check the Nutrition Facts Label for sodium and choose products with lower sodium content.',
    'Season foods with herbs, spices, garlic, onions, peppers and lemon or lime juice to add flavor and heart benefits',
    'One of the most important nutrients for heart health is soluble fiber',
    'Eating soluble fiber can help lower your cholesterol level and better manage blood sugar levels.',
    'Leafy green vegetables like spinach, kale and collard greens are well-known for their wealth of vitamins, minerals and antioxidants which helps the heart',
    'Strawberries, blueberries, blackberries and raspberries are jam-packed with important nutrients that play a central role in heart health',
    'Avocados are an excellent source of heart-healthy monounsaturated fats,',
    'Avocados are also rich in potassium, a nutrient that’s essential to heart health.',
    'one avocado supplies 975 milligrams of potassium, or about 28% of the amount that you need in a day',
    'Getting at least 4.7 grams of potassium per day can decrease blood pressure',
    'Walnuts are a great source of fiber and micronutrients like magnesium, copper and manganese which help your heart',
    'eating beans can reduce certain risk factors for heart disease.',
    'Dark chocolate is rich in antioxidants like flavonoids, which can help boost heart health.',
    'studies have associated eating chocolate with a lower risk of heart disease.',
    'Tomatoes are loaded with lycopene, a natural plant pigment with powerful antioxidant properties which helps the heart in a lot of ways',
    'Antioxidants help neutralize harmful free radicals, preventing oxidative damage and inflammation, both of which can contribute to heart disease.',
    'Low blood levels of lycopene are linked to an increased risk of heart attack and stroke ',
    'Almonds are incredibly nutrient-dense, boasting a long list of vitamins and minerals that are crucial to heart health.',
    'almonds are a good source of heart-healthy monounsaturated fats and fiber, two important nutrients that can help protect against heart disease',
    'Chia seeds, flaxseeds and hemp seeds are all great sources of heart-healthy nutrients, including fiber and omega-3 fatty acids.',
    'flaxseed may help keep blood pressure and cholesterol levels under control.',
    'garlic can even help improve heart health.',
    'Be sure to consume garlic raw, or crush it and let it sit for a few minutes before cooking. This allows for the formation of allicin, maximizing its potential health benefits.',
    'Olive oil is packed with antioxidants, which can relieve inflammation and improve heart health',
    'olive oil is rich in monounsaturated fatty acids, and many studies have associated it with improvements in heart health.',
    'Take advantage of the many benefits of olive oil by drizzling it over cooked dishes or adding it to vinaigrettes and sauces.',
    'Olive oil is high in antioxidants and monounsaturated fats. It has been associated with lower blood pressure and heart disease risk.',
    'Green tea has been associated with a number of heart-healthy benefits, from increased fat burning to improved insulin sensitivity',
    'Green tea is also brimming with polyphenols and catechins, which can act as antioxidants to prevent cell damage, reduce inflammation and protect the health of your heart.',
    'Taking a green tea supplement or drinking matcha, a beverage that is similar to green tea but made with the whole tea leaf, may also benefit heart health.',
    'What you put on your plate can influence just about every aspect of heart health',
    'Including these heart-healthy foods as part of a nutritious, well-balanced diet can help keep your heart in good shape',
    'Eat more vegetables, fruits, and whole grains.',
    'At least 5 cups of fruits and vegetables and three 1-ounce servings of whole grains a day keeps your heart strong',
    'Eat more beans, legumes (like lentils), seeds, and nuts',
    '4 servings of either nuts, seeds, or legumes such as black beans, garbanzos (also called chickpeas), or lentils per week help boost heart health',
    'Put healthier fats to work for you. ',
    'Omega-3s seem to lower triglycerides, fight plaque in your arteries, lower blood pressure, and reduce your risk of abnormal heart rhythms.',
    'Eat lean protein.',
    'Make beans and nuts your mainstays, and keep portions in check.',
    ' If you’re craving some type of processed meat -- bacon, deli meats, hot dogs, sausage, chicken nuggets, or jerky -- limit those.',
    'Feed your body regularly.',
    ' Try using dried herbs and spices instead of salt',
    'Exercise. Be as active as possible. It strengthens your heart, improves blood flow, raises "good" HDL cholesterol, and helps control blood sugar and body weight.',
    'If you smoke, quit.',
    'Quitting smoking will lower your risk of death from heart disease by 33%.',
    'Pay attention to nutrition labels.',
    'Recognize healthy fats.',
    'Find flavorful alternatives to salt.',
    'Because most canned foods are high in sodium, it is recommended to stick to frozen or fresh vegetables instead',
    'Avoid unhealthy processed food.',
    'focus on combining single ingredient foods that contain no added chemicals',
    'choose fresh foods instead of processed whenever possible.',
    'leafy green vegetables, whole grains, berries, walnuts and almonds, fatty fish and dried beans help your heart in a lot of ways',
    'Garlic, olive oil, edamame and avocado are also among some of the healthiest foods to add to your daily diet.',
    'Embrace a healthy plant based diet.',
    'plant based diet provides rich fiber, vitamins and minerals which are important for the heart',
    'eat more colorful fruits and vegetables—fresh or frozen',
    'eat more high-fiber cereals, breads, and pasta made from whole grains or legumes',
    'eat less trans fats from partially hydrogenated or deep-fried foods; saturated fats from fried food, fast food, and snack foods.',
    'eat less packaged foods, especially those high in sodium and sugar',
    'eat less white breads, sugary cereals, refined pastas or rice',
    'eat less yogurt with added sugar; processed cheese',
    'Cut out trans fats',
    'Limit saturated fats.',
    'Eat more healthy fats.',
    'Don’t replace fat with sugar or refined carbs',
    'When cutting back on heart-risky foods, such unhealthy fats, it’s important to replace them with healthy alternatives.',
    'Instead of sugary soft drinks, white bread, pasta and processed foods like pizza, opt for unrefined whole grains like whole wheat or multigrain bread, brown rice, barley, quinoa, bran cereal, oatmeal, and non-starchy vegetables.',
    'Focus on high-fiber food',
    'A diet high in fiber can lower “bad” cholesterol and provide nutrients that help protect your heart',
    'Steer clear of salt and processed foods',
    'Reduce canned or processed foods',
    'Use spices for flavor.',
    'Substitute reduced sodium versions, or salt substitutes.',
    'Make use of the many delicious alternatives to salt. Try fresh herbs like basil, thyme, or chives',
    'Choose your condiments and packaged foods carefully, looking for foods labeled sodium free, low sodium, or unsalted.',
    'Rekindle home cooking',
    'Use heart healthy cooking methods.',
    'You should bake, broil, roast, steam, poach, lightly stir fry, or sauté ingredients—using a small amount of olive oil, reduced sodium broth, and spices instead of salt.',
    'eat more healthy fats like unsalted nuts, olive oil, flax seed and avocados',
    'eat more fruit, vegetables and legumes like lentils and other beans',
    'eat more high-fiber, low-sugar whole grain cereals, breads and pastas',
    'eat less packaged food, especially those high in sodium and sugar',
    'eat less white bread, sugary cereals and refined pasta or rice',
    'eat less processed meat such as bacon, sausage, deli meats or fried chicken',
    'eat less yogurt with added sugar or processed cheese',
    'eat less sugar sweetened beverages, candy, cookies and grain based desserts',
    'Limit Bad Fat',
    'Say No to Salt',
    'Opt for Low-Fat Dairy',
    'Go for Whole Grains',
    'A heart healthy diet requires more than just evaluating what you’re eating.',
    'Exercise offers a huge assist whether your goal is to lose weight, strengthen your heart or simply maintain the healthy shape you’re in.',
    'Working out regularly can reduce blood pressure and cholesterol levels and it can also keep your metabolism up to speed',
    'Choose Fresh or frozen vegetables and fruits',
    'choose Low-sodium canned vegetables',
    'choose Canned fruit packed in juice or water',
    'limit Coconut',
    'limit Vegetables with creamy sauces',
    'limit Fried or breaded vegetables',
    'limit canned fruit packed in heavy syrup',
    'limit frozen fruit with sugar added',
    'choose Whole-wheat flour',
    'choose Whole-grain bread, preferably 100% whole-wheat bread or 100% whole-grain bread',
    'choose High-fiber cereal with 5 g or more fiber in a serving',
    'choose Whole grains such as brown rice, barley and buckwheat (kasha)',
    'choose Whole-grain pasta',
    'choose Oatmeal (steel-cut or regular)',
    'avoid White, refined flour',
    'avoid White bread',
    'avoid Muffins',
    'avoid Frozen waffles',
    'avoid Corn bread',
    'avoid Doughnuts',
    'avoid Biscuits',
    'avoid Quick breads',
    'avoid Cakes',
    'avoid Pies',
    'avoid Egg noodles',
    'avoid Buttered popcorn',
    'avoid High-fat snack crackers',
    'No more than 5 to 6% of your total daily calories, or no more than 11 to 13g of saturated fat if you follow a 2,000-calorie-a-day diet',
    'Add Olive oil to your diet',
    'Add Canola oil to your diet',
    'Add Vegetable and nut oils to your diet',
    'Add Margarine, trans fat free to your diet',
    'Add Cholesterol-lowering margarine, such as Benecol, Promise Activ or Smart Balance to your diet',
    'Add Nuts, seeds to your diet',
    'Add Avocados to your diet',
    'Try to limit Butter in your diet',
    'Consume Legumes for a healthy heart',
    'Consume Soybeans and soy products, such as soy burgers and tofu for a healthy heart',
    'Try to limit Gravy in your diet',
    'Try to limit Cream sauce in your diet',
    'Try to limit Nondairy creamers in your diet',
    'Try to limit Hydrogenated margarine and shortening in your diet',
    'Try to limit Cocoa butter, found in chocolate in your diet',
    'Try to limit Coconut, palm, cottonseed and palm-kernel oils in your diet',
    'Consume Low-fat dairy products, such as skim or low-fat (1%) milk, yogurt and cheese for a healthy heart',
    'Limit or avoid Full-fat milk and other dairy products',
    'Reduce the sodium in your food',
    'Limit or avoid Table salt'
  ];

  static List<String> nonVegTips = [
    'Good fats from vegetables, nuts, seeds and fish can reduce the risk of heart disease,',
    'Many fish, such as salmon, tuna, sardines, and herring, are rich sources of omega-3 fatty acids.',
    ' Try to eat fish at least twice a week for a healthy heart',
    'C, NV, CN',
    'Focus on foods like fish, nuts, avocado and olive oil.',
    'Salmon is chock full of omega-3 fatty acids, which can decrease the risk of abnormal heartbeats',
    'two servings of omega-3 rich foods like salmon each week. A serving size is 3.5 ounces of cooked fish is recommended for a healthy heart',
    'Tuna salad (light on the mayo) is an easy lunch snack that will keep you full and your heart healthy',
    'f you eat meat, select lean cuts of beef and pork, especially cuts with "loin" or "round" in their name.',
    ' Cut back on processed meats high in saturated fat, such as hot dogs, salami and bacon.',
    'Bake, broil, roast, stew or stir-fry lean meats, fish or poultry.',
    'Drain the fat off of cooked, ground meat.',
    'Eat fish regularly. Try different ways of cooking such as baking, broiling, grilling and poaching to add variety.',
    'Eat two 4-ounce portions of fatty fish each week, such as salmon, lake trout, albacore tuna (in water, if canned), mackerel and sardines.',
    'Fatty fish like salmon, mackerel, sardines and tuna are loaded with omega-3 fatty acids, which have extensive heart-health benefits.',
    'If you don’t eat much seafood, fish oil is another option for getting your daily dose of omega-3 fatty acids.',
    'Fatty fish and fish oil are both high in omega-3 fatty acids and may help your heart considerably',
    'Eat fish that are high in omega-3 fatty acids, including albacore tuna, salmon, and sardines.',
    'Make beans, nuts, fish, and chicken your mainstays, and keep portions in check.',
    'eat at least two 3.5-ounce servings of fish a week for a healthy heart',
    'Some cuts of meat have more fat than others, so look for leaner choices to help your heart ',
    'try using rosemary, garlic, or sage instead of salt for chicken',
    'try dill or tarragon instead of salt for fish ',
    'eat more high-quality protein, such as fish and poultry',
    'eat more organic dairy such as eggs, skim milk, or unsweetened yogurt',
    'eat less white or egg breads, sugary cereals, refined pastas or rice',
    'eat less processed meat such as bacon, sausage, and salami, and fried chicken',
    'eat more healthy fats, such as raw nuts, olive oil, fish oils, flaxseeds, and avocados',
    'Replacing processed meats with fish or chicken, for example, can make a positive difference to your health.',
    'Eating fresh foods, looking for unsalted meats, and making your own soups or stews can dramatically reduce your sodium intake.',
    'eat more high-quality protein such as fish, skinless poultry and lean meats',
    'Choose Meat Carefully',
    'You should consume no more than 6 ounces of meat, cooked, per day,',
    'You can reduce the amount of saturated fat in your diet by trimming fat off your meat or choosing lean meats with less than 10 percent fat.',
    'Limit or avoid Organ meats, such as liver',
    'Limit or avoid Fatty and marbled meats',
    'Limit or avoid Spareribs',
    'Limit or avoid Hot dogs and sausages',
    'Limit or avoid Bacon',
    'Limit or avoid Fried or breaded meats',
    'Try to limit Lard in your diet',
    'Try to limit Bacon fat in your diet',
    'Consume Eggs for a healthy heart',
    'Consume Lean ground meats for a healthy heart',
    'Consume Fish, especially fatty, cold-water fish, such as salmon for a healthy heart',
    'Consume Skinless poultry for a healthy heart',
  ];
}
