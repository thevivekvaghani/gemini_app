import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gen_ai_sample/widgets/app_elevated_button.dart';
import 'package:gen_ai_sample/widgets/app_text_form_field.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FindNearArea extends StatefulWidget {
  const FindNearArea({super.key});

  @override
  State<FindNearArea> createState() => _FindNearAreaState();
}

class _FindNearAreaState extends State<FindNearArea> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController foodPreferenceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? response;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Find your best routes in \nyour trips plan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  titleText: "From Location",
                  hintText: "From Location",
                  controller: fromController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AppTextFormField(
                  titleText: "To Location",
                  hintText: "To Location",
                  controller: toController,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  titleText: "Budget",
                  hintText: "Budget",
                  controller: budgetController,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: AppTextFormField(
                  titleText: "Food Preference",
                  hintText: "Food Preference",
                  controller: foodPreferenceController,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppElevatedButton(
                text: "Submit",
                onPressed: () async {
                  final text = "Create an itinerary from below information "
                      "\n From Location: ${fromController.text}"
                      "\n to location: ${toController.text}"
                      "\n budget: ${budgetController.text} inr"
                      "\n Food Preference: ${foodPreferenceController.text}"
                      "\n Activity Like: Moutain, Beach, Nature, Waterfall"
                      "\n give me the response in day-wise format";
                  try {
                    final apiKey = dotenv.env['API_KEY'];
                    setState(() {
                      isLoading = true;
                      response = null;
                    });
                    if (apiKey?.isEmpty ?? true) {
                      setState(() {
                        isLoading = false;
                      });
                      throw "Something Went Wrong";
                    } else {
                      final model =
                          GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
                      final content = [Content.text(text)];
                      final res = await model.generateContent(content);
                      print("response ${res.text.toString()}");
                      setState(() {
                        isLoading = false;
                        response = res.text;
                      });
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                      response = null;
                    });
                    print("Error $e");
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if ((response?.isEmpty ?? true) && isLoading)
            Row(
              children: [
                SizedBox(
                  height: 50,
                  child: LoadingAnimationWidget.waveDots(
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          if (response?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0048D0),
                    ),
                    child: const Icon(
                      Icons.ac_unit_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffC7CFFF),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: MarkdownBody(
                        data: response ?? "",
                        onTapLink: (text, href, title) {
                          // launch(
                          //   href!,
                          // );
                        },
                        styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                        styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.start,
                          p: TextStyle(
                            fontSize: 16,
                          ),
                          h1: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
