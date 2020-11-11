import styled from "styled-components";

export const IssueComp = styled.div`
  border-top: 1px solid #ced4da;
  padding-top: 1%;
  padding-bottom: 1%;
  display: flex;
`;

export const IssueInfo = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 2%;
  position: relative;
`;

export const IssueTitle = styled.div`
  font-weight: bold;
  color: black;
  margin-left: 1.5%;
  margin-right: 1.5%;
`;

export const IssueEtc = styled.div`
  display: flex;
  font-size: 12px;
`;

export const ExclamationWrapper = styled.div`
  margin-left: 0.5%;
  margin-right: 0.5%;
`;

export const VscMilestoneWrapper = styled.div`
  margin-right: 20px;
`;

export const IssueEtcWrapper = styled.div`
  margin-right: 5px;
`;

export const LabelWrapper = styled.div`
  margin-left: 0.5%;
  margin-right: 0.5%;
`;

export const ProfileImageWrapper = styled.div<{ size: number }>`
  position: absolute;
  left: ${(props) => props.size}%;
`;
