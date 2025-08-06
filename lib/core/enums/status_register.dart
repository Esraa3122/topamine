enum AccountStatus {
  pending,
  accepted,
  rejected,
}

AccountStatus mapStringToAccountStatus(String status) {
  switch (status.trim()) {
    case 'قيد المراجعة':
      return AccountStatus.pending;
    case 'تم القبول':
      return AccountStatus.accepted;
    case 'تم الرفض':
      return AccountStatus.rejected;
    default:
      return AccountStatus.pending; 
  }
}

String? mapAccountStatusToString(AccountStatus? status) {
  switch (status) {
    case AccountStatus.pending:
      return 'قيد المراجعة';
    case AccountStatus.accepted:
      return 'تم القبول';
    case AccountStatus.rejected:
      return 'تم الرفض';
    default:
      return null;
  }
}
