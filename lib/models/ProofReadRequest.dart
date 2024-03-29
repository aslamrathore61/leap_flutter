class ProofReadRequest {
  String? comment;
  String? correctionImage;
  String? proofReadStatus;
  String? vcardProofReadUuid;

  ProofReadRequest(
      {this.comment,
        this.correctionImage,
        this.proofReadStatus,
        this.vcardProofReadUuid});

  ProofReadRequest.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    correctionImage = json['correctionImage'];
    proofReadStatus = json['proofReadStatus'];
    vcardProofReadUuid = json['vcardProofReadUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['correctionImage'] = this.correctionImage;
    data['proofReadStatus'] = this.proofReadStatus;
    data['vcardProofReadUuid'] = this.vcardProofReadUuid;
    return data;
  }
}