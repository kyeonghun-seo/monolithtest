import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monolithtest/controller/ReservationController.dart';
import 'package:monolithtest/model/Date.dart';
import 'package:monolithtest/model/Ticket.dart';
import 'package:monolithtest/model/TicketTime.dart';
import 'package:monolithtest/theme/theme.dart';
import 'package:monolithtest/ui/common/HorizontalScrollCalendar.dart';
import 'package:monolithtest/ui/common/TouchBox.dart';
import 'package:monolithtest/ui/common/TouchIconBox.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  void initState() {
    ReservationContoller.to.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReservationContoller>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
          child: Column(
            children: [
              const _ReservationTopBar(),
              const _ReservationStepInformation(),
              HorizontalScrollCalendar(
                dates: controller.dates,
                selectedDate: controller.selectedDate,
                onTapDate: (Date date) {
                  controller.selectDate(date);
                },
              ),
              Expanded(
                child: ReservationTicketTimeList(
                  selectedTicket: controller.selectedTicket,
                ),
              ),
              _ReservationBottomActionBar(
                enableNext: controller.selectedTicketTime != null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReservationTopBar extends StatelessWidget {
  const _ReservationTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: pageSideMargin, right: 10),
      height: actionBarHeight,
      child: Row(
        children: [
          const Text(
            '날짜 시간 선택',
            style: titleTextStyle,
          ),
          const Spacer(),
          TouchIconBox(
            icon: 'ic_close',
            onTap: (box) {},
            padding: 16.0,
          ),
        ],
      ),
    );
  }
}

enum StepStatus {
  done,
  progress,
  pending,
}

class _ReservationStepInformation extends StatelessWidget {
  const _ReservationStepInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepChip(
            stepName: '티켓선택',
            stepIcon: 'ic_check',
            stepStatus: StepStatus.done,
          ),
          _buildStepDivider(stepStatus: StepStatus.done),
          _buildStepChip(
              stepName: '시간선택',
              stepIcon: 'ic_datetime',
              stepStatus: StepStatus.progress),
          _buildStepDivider(stepStatus: StepStatus.pending),
          _buildStepChip(
            stepName: '결제하기',
            stepIcon: 'ic_coin',
            stepStatus: StepStatus.pending,
          ),
        ],
      ),
    );
  }

  Widget _buildStepChip({
    required String stepName,
    required String stepIcon,
    required StepStatus stepStatus,
  }) {
    return Container(
      width: 86.0,
      height: 28.0,
      decoration: BoxDecoration(
        color:
            stepStatus == StepStatus.done ? Colors.indigo : Colors.transparent,
        borderRadius: BorderRadius.circular(14.0),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
            color: stepStatus == StepStatus.pending
                ? CupertinoColors.lightBackgroundGray
                : Colors.indigo,
            width: 1),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: stepStatus == StepStatus.pending
                    ? CupertinoColors.lightBackgroundGray
                    : Colors.indigo,
                width: 1,
              ),
              color: stepStatus == StepStatus.pending
                  ? Colors.transparent
                  : Colors.indigo,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/$stepIcon.png',
                width: 14.0,
                color: stepStatus == StepStatus.pending
                    ? CupertinoColors.lightBackgroundGray
                    : Colors.white,
              ),
            ),
          ),
          Text(
            stepName,
            style: smallTextStyle.copyWith(
              color: stepStatus == StepStatus.progress
                  ? Colors.indigo
                  : CupertinoColors.lightBackgroundGray,
            ),
          ).marginOnly(left: 6.0),
        ],
      ),
    );
  }

  Widget _buildStepDivider({
    required StepStatus stepStatus,
  }) {
    final color = stepStatus == StepStatus.done
        ? Colors.indigo
        : CupertinoColors.lightBackgroundGray;
    return Row(
      children: [
        CircleAvatar(
          radius: 1.5,
          backgroundColor: color,
        ).marginOnly(left: 6.0, right: 2.0),
        CircleAvatar(
          radius: 1.5,
          backgroundColor: color,
        ).marginOnly(left: 2.0, right: 6.0),
      ],
    );
  }
}

class _ReservationBottomActionBar extends StatelessWidget {
  const _ReservationBottomActionBar({
    required this.enableNext,
    Key? key,
  }) : super(key: key);

  final bool enableNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
      child: Row(
        children: [
          Container(
            width: 120,
            height: actionBarHeight,
            color: CupertinoColors.lightBackgroundGray,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                '이전',
                style: buttonTextStyle,
              ),
            ),
          ),
          Expanded(
            child: AnimatedOpacity(
              duration: 300.milliseconds,
              curve: Curves.easeInOutBack,
              opacity: enableNext ? 1 : 0.5,
              child: Container(
                height: actionBarHeight,
                color: Colors.yellow,
                child: IgnorePointer(
                  ignoring: !enableNext,
                  child: TextButton(
                    onPressed: () {
                      _showSelectedTicketDetails();
                    },
                    child: const Text(
                      '다음',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectedTicketDetails() {
    Get.bottomSheet(
      Container(
        height: 300,
        padding: EdgeInsets.only(
          left: pageSideMargin,
          right: pageSideMargin,
          bottom: Get.mediaQuery.padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTicketDetailOptionItem(
                title: '상품명',
                content:
                    ReservationContoller.to.selectedTicket?.productName ?? ''),
            _buildTicketDetailOptionItem(
                title: '구매날짜',
                content: ReservationContoller.to.selectedDate?.date ?? ''),
            _buildTicketDetailOptionItem(
                title: '구매시간',
                content:
                    ReservationContoller.to.selectedTicketTime?.timeSlot ?? ''),
          ],
        ),
      ),
      enterBottomSheetDuration: 150.milliseconds,
      exitBottomSheetDuration: 150.milliseconds,
    );
  }

  Widget _buildTicketDetailOptionItem({
    required String title,
    required String content,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: CupertinoColors.extraLightBackgroundGray))),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(content),
        ],
      ),
    );
  }
}

class ReservationTicketTimeList extends StatelessWidget {
  const ReservationTicketTimeList({
    required this.selectedTicket,
    Key? key,
  }) : super(key: key);

  final Ticket? selectedTicket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: pageSideMargin,
              right: pageSideMargin,
              top: 30.0,
              bottom: 12.0),
          child: Row(
            children: [
              Text(
                selectedTicket?.productName ?? '날짜를 선택해 주세요',
                style: normalTextStyle,
              ),
              const Spacer(),
              if (ReservationContoller.to.selectedDate != null)
                Text(ReservationContoller.to.selectedDate?.date ?? ''),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 65.0,
              mainAxisSpacing: itemGapMargin, //수평 Padding
              crossAxisSpacing: itemGapMargin, //수직 Padding
            ),
            padding: const EdgeInsets.only(
                left: pageSideMargin, right: pageSideMargin, bottom: 30.0),
            itemCount: selectedTicket?.timeList.length ?? 0,
            itemBuilder: (context, index) {
              final item = selectedTicket?.timeList[index];
              if (item != null) {
                return _TicketTime(ticketTime: item);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TicketTime extends StatelessWidget {
  const _TicketTime({
    required this.ticketTime,
    Key? key,
  }) : super(key: key);

  final TicketTime ticketTime;

  @override
  Widget build(BuildContext context) {
    final isSelected = ReservationContoller.to.selectedTicketTime == ticketTime;
    return IgnorePointer(
      ignoring: !ticketTime.enabled,
      child: TouchBox(
        onTap: (box) {
          ReservationContoller.to.selectTicketTime(ticketTime);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ticketTime.enabled
                ? Colors.transparent
                : CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: isSelected
                  ? Colors.blue
                  : CupertinoColors.lightBackgroundGray,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ticketTime.timeSlot,
                style: normalTextStyle.copyWith(
                  color: ticketTime.enabled ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                ticketTime.stockStatusStr,
                style: normalTextStyle.copyWith(color: stockStatusColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get stockStatusColor {
    switch (ticketTime.stockStatusStr) {
      case '여유':
        return Colors.green;
      case '보통':
        return Colors.blue;
      case '혼잡':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
