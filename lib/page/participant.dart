import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:streaming/utility/utility.dart';

class Particpant extends StatefulWidget {
  final String userName;
  final String channalName;
  final int? uid;
  const Particpant(
      {super.key, required this.userName, required this.channalName, this.uid});

  @override
  State<Particpant> createState() => _ParticpantState();
}

class _ParticpantState extends State<Particpant> {
  List<int>? _user;
  late RtcEngine _engine; //handle video call
  AgoraRtmClient? client; //logging into agoraRTM
  AgoraRtmChannel? channel; //joining the channal

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilizeAgora();
  }

  Future<void> initilizeAgora() async {
    client = await AgoraRtmClient.createInstance(appId);
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _engine.enableVideo(); //by default agora start with audio
    _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    //calls back for rtc engine
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _user?.add(connection.localUid!);
        });
      },
    ));
    //call back for rtm clinet

    client?.onMessageReceived = (AgoraRtmMessage message, peerId) {
      debugPrint('Private message from ${peerId} ${message.text}');
    }; //when received a separate message from the user directly to you
//give reason why the connection state changes
    client?.onConnectionStateChanged = (state, reason) {
      debugPrint(
          'connection state changes${state.toString()} reason ${reason.toString}');

      if (state == 5) {
        channel?.leave();
        channel?.close();
        debugPrint('channal aborted and log out');
      }
    };
    //join the RTM and RTC channels
    //we have to connetc rtm id and rtc id for the userId
    await client?.login(null, widget.uid!.toString());
    channel = await client?.createChannel(widget.channalName);
    await channel?.join();
    await _engine.joinChannel(
        token: '',
        channelId: widget.channalName,
        uid: widget.uid!,
        options: ChannelMediaOptions());
//callback for rtm channal
    channel?.onMemberJoined = (member) {
      debugPrint(
          'Member Joined ${member.userId} , channal ${member.channelId}');
    };
    channel?.onMemberLeft = (member) {
      debugPrint('Member left ${member.userId} , channal ${member.channelId}');
    };
    //which member send the message
    channel?.onMessageReceived = (message, fromMember) {
      //TODO:implement this
      debugPrint('Public message from ${fromMember.userId} :  ${message.text}');
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('participant'),
      ),
    );
  }
}
