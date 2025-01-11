import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem5_walle/CONSTANTS/constants.dart';
import 'package:sem5_walle/PAGES/helppage.dart';
import 'package:sem5_walle/PAGES/homepage.dart';
import 'package:sem5_walle/AUTHPROVIDER/authservice.dart';


void main() => runApp(const HomePage1());

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  static const String prompt = "Identify The Image And If It's A Plant Provide Me It's Scientific Information,Medicinal Properties,caring instructions,cliimate it needs & it's health in detail and if it's not a plant tell me what you see in the image briefly ";
    //  "Tell me about the given plant with all it's information like Name,Genus,Sub genus,Scientific name,Medicinal properties if any,the climate it needs,caring instructions also tell me if the plant looks healthy from the image I've Provided";

  final AuthService _authService = AuthService();
  final Gemini gemini = Gemini.reInitialize(apiKey: API_KEY);

  List<ChatMessage> messages = [];
  final List<ChatUser> _typing = [];

  ChatUser currentuser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiuser = ChatUser(
      id: "1",
      firstName: "Wall-e",
      profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Wall-e",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 153, 255, 153),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            color: Colors.black,
            onPressed:(){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> HelpPage()));
              },
          ),
          IconButton(
            onPressed: ()
            async{
              await _authService.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(Icons.logout_outlined),
            color: Colors.black,
          )
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.greenAccent, BlendMode.multiply),
          opacity: 0.5,
          image: AssetImage("assets/appbg1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: DashChat(
        inputOptions: InputOptions(
          textInputAction: TextInputAction.none,
          alwaysShowSend: false,
          inputDisabled: true,
          inputToolbarMargin: EdgeInsets.zero,
          inputDecoration: const InputDecoration(
            enabled: true,
            isDense: true,
            isCollapsed: true,
          ),
          trailing: [
            IconButton(
              onPressed: _sendMediaMessageCam,
              icon: const Icon(Icons.camera_alt_sharp),
              color: Colors.black,
            ),
            IconButton(
              onPressed: _sendMediaMessageGal,
              icon: const Icon(Icons.photo),
              color: Colors.black,
            ),
          ],
        ),
        currentUser: currentuser,
        onSend: _sendMessage,
        messages: messages,
        typingUsers: _typing,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage,...messages];
      _typing.add(geminiuser);
    });
    try {
      if (chatMessage.medias != null && chatMessage.medias?.isNotEmpty == true) {
        // Pass the image to the Gemini AI for processing
        String response = '';
        GenerationConfig generationConfig = GenerationConfig(
          maxOutputTokens: 800,
        );
        await gemini.streamGenerateContent(
            prompt,
            images: chatMessage.medias?.map((media) => File(media.url).readAsBytesSync()).toList(),
            generationConfig: generationConfig
        )
            .forEach((event) {
          String responsePart = event.content?.parts?.fold(
              "",
                  (previous, current) => "$previous ${current.text}"
          ) ?? "";
          response += responsePart;
        });
        ChatMessage message = ChatMessage(
            user: geminiuser, createdAt: DateTime.now(), text: response
        );
        setState(() {
          messages = [message,...messages];
          _typing.remove(geminiuser);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessageCam() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (file!= null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentuser,
          createdAt: DateTime.now(),
          text: '',
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }

  void _sendMediaMessageGal() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file!= null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentuser,
          createdAt: DateTime.now(),
          text: '',
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }
}