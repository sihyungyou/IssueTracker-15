import styled from "styled-components";

interface Container {
  width: string;
}
export const NavButton = styled.div<Container>`
  width: ${(props) => props.width};
  padding-top: 0.35rem;
  padding-bottom: 0.35rem;
  padding-left: 10%;
  display: flex;
  align-contents: center;
  color: #586069;
  border-radius: 6px;
  background-color: #fafbfc;
  border: 1px solid #ced4da;
  justify-contents: center;
`;

export const NavButtonTitle = styled.div`
  margin-left: 3%;
  text-align: center;
  font-weight: bolder;
`;

export const NavButtonCountWrapper = styled.div`
  text-align: center;
  width: 18px;
  margin-left: 6%;
  border-radius: 50%;
  background-color: #e8eaec;
`;
