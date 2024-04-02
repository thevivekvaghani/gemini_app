import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gen_ai_sample/view/find_near_place.dart';
import 'package:gen_ai_sample/widgets/app_text_form_field.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GenAi extends StatefulWidget {
  const GenAi({Key? key}) : super(key: key);

  @override
  State<GenAi> createState() => _GenAiState();
}

class _GenAiState extends State<GenAi> {
  TextEditingController searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? response;
  bool isLoading = false;
  XFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gen Ai"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindNearArea(),
                ),
              );
            },
            icon: const Icon(
              Icons.ac_unit_sharp,
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (searchController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffDCE1FC),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            child: Text(
                              searchController.text,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
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
                                styleSheetTheme:
                                    MarkdownStyleSheetBaseTheme.material,
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              color: const Color(0xffDCE1FC),
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                6,
                16,
              ),
              child: Row(
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.add,
                  //   ),
                  // ),
                  Expanded(
                    child: AppTextFormField(
                      hintText: "Ask AI",
                      fillColor: Colors.white,
                      controller: searchController,
                      contentPadding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        0,
                        16,
                      ),
                      borderRadius: 36,
                      suffixIconConstraints: const BoxConstraints(
                        maxWidth: 82,
                      ),
                      suffixIcon: Row(
                        children: [
                          if (searchController.text.isEmpty)
                            const SizedBox(
                              width: 40,
                            ),
                          const Icon(
                            Icons.mic_none,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          // if (searchController.text.isNotEmpty)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final file = await ImagePicker().pickMultipleMedia();
                      if (file.isNotEmpty) {
                        print("file length ${file.length}");
                        if (file.length > 1) {
                          print("file length ${file.first.path}");
                          print("file length ${file.last.path}");
                          final text = searchController.text;
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
                              final model = GenerativeModel(
                                  model: 'gemini-pro-vision', apiKey: apiKey!);
                              final (firstImage, secondImage) = await (
                                File(file.first.path).readAsBytes(),
                                File(file.last.path).readAsBytes()
                              ).wait;
                              final prompt = TextPart(
                                  "What's different between these pictures?");
                              final imageParts = [
                                DataPart(
                                    'image/${file.first.path.split('.').last}',
                                    firstImage),
                                DataPart(
                                    'image/${file.last.path.split('.').last}',
                                    secondImage),
                              ];
                              final res = await model.generateContent([
                                Content.multi([prompt, ...imageParts])
                              ]);
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
                            print("Error ::: $e");
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff798EFF),
                      ),
                      child: const Icon(
                        Icons.attach_file,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final text = searchController.text;
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
                          final model = GenerativeModel(
                              model: 'gemini-pro', apiKey: apiKey!);
                          final content = [Content.text(text)];
                          final res = await model.generateContent(content);
                          print("response ${res.toString()}");
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
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff798EFF),
                      ),
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
